# Pre-release checks: builds the site and validates the output.
#
# Usage: bundle exec ruby scripts/check-site.rb [--external] [--skip-build]
#   --external    also check links to other sites (slow, can be flaky)
#   --skip-build  check the last build instead of rebuilding
#
# Exits non-zero if any errors are found. Runs automatically before
# `git push public` via .githooks/pre-push.

require "date"
require "json"
require "net/http"
require "nokogiri"
require "set"
require "tmpdir"
require "uri"
require "yaml"

ROOT = File.expand_path("..", __dir__)
CONFIG = YAML.safe_load(File.read(File.join(ROOT, "_config.yml")))
SITE_URL = CONFIG.fetch("url")
SITE_HOST = URI(SITE_URL).host
DEST = File.join(Dir.tmpdir, "knowingken-check")
MAX_DESCRIPTION = 160
POST_FIELDS = %w[layout title slug date].freeze
STRAY_FILES = /(\.md|\.markdown|WORKFLOW.*|\.stackdump)\z/i
EXTERNAL_SOFT_FAILS = [401, 403, 429, 999].freeze # bot-blocking, not broken

external = ARGV.include?("--external")
@errors = []
@warnings = []

def error(where, msg) = @errors << "#{where}: #{msg}"
def warning(where, msg) = @warnings << "#{where}: #{msg}"

# --- Build -------------------------------------------------------------------

unless ARGV.include?("--skip-build")
  puts "Building site..."
  ok = system({ "JEKYLL_ENV" => "production" },
              "bundle", "exec", "jekyll", "build", "--quiet",
              "--source", ROOT, "--destination", DEST)
  abort "Build failed." unless ok
end
abort "No built site at #{DEST}; run without --skip-build." unless File.file?(File.join(DEST, "index.html"))

# --- Source checks -----------------------------------------------------------

Dir[File.join(ROOT, "_posts", "*")].sort.each do |path|
  name = File.join("_posts", File.basename(path))
  front = File.read(path, encoding: "utf-8")[/\A---\s*\n(.*?)\n---/m, 1]
  next error(name, "missing front matter") unless front

  data = YAML.safe_load(front, permitted_classes: [Date, Time]) || {}
  next if data["published"] == false

  missing = POST_FIELDS.reject { |field| data[field] }
  error(name, "missing front matter: #{missing.join(', ')}") if missing.any?
  error(name, "layout should be 'post', got '#{data['layout']}'") if data["layout"] && data["layout"] != "post"
  error(name, "needs a description or subtitle") unless data["description"] || data["subtitle"]
end

# --- Output checks -----------------------------------------------------------

Dir.glob("**/*", base: DEST).each do |file|
  error(file, "should not be published") if file.match?(STRAY_FILES)
end

# Returns the built file a site path points to, or nil.
def resolve(path)
  path = URI.decode_uri_component(path.sub(/[?#].*/, ""))
  candidates = path.end_with?("/") ? ["#{path}index.html"] : [path, "#{path}.html", "#{path}/index.html"]
  candidates.map { |c| File.join(DEST, c) }.find { |c| File.file?(c) }
end

def ids_in(file)
  (@ids ||= {})[file] ||= Nokogiri::HTML(File.read(file, encoding: "utf-8")).css("[id]").map { |el| el["id"] }.to_set
end

external_links = Hash.new { |h, k| h[k] = Set.new }
pages = Dir.glob("**/*.html", base: DEST).sort

pages.each do |page|
  doc = Nokogiri::HTML(File.read(File.join(DEST, page), encoding: "utf-8"))
  page_dir = "/#{File.dirname(page)}/".sub(%r{/\./\z}, "/")

  # Metadata
  error(page, "empty <title>") if doc.at("title")&.text.to_s.strip.empty?

  desc = doc.at('meta[name="description"]')&.[]("content").to_s
  if desc.empty?
    error(page, "missing meta description")
  elsif desc.match?(/&(amp|lt|gt|quot|#\d+);|↩/)
    error(page, "description contains escaped HTML or footnote markers: #{desc[0, 60]}")
  elsif desc.end_with?("...")
    error(page, "description truncated (over #{MAX_DESCRIPTION} chars)")
  elsif desc == CONFIG["description"].to_s.strip && !%w[index.html 404.html].include?(page)
    warning(page, "no description; falling back to site description")
  end

  canonical = doc.at('link[rel="canonical"]')&.[]("href").to_s
  if page == "404.html"
    error(page, "should be noindex") unless doc.at('meta[name="robots"][content*="noindex"]')
  elsif !canonical.start_with?(SITE_URL)
    error(page, "canonical '#{canonical}' doesn't start with #{SITE_URL}")
  end

  json_ld = doc.css('script[type="application/ld+json"]')
  error(page, "missing JSON-LD") if json_ld.empty?
  json_ld.each do |script|
    JSON.parse(script.text)
  rescue JSON::ParserError => e
    error(page, "invalid JSON-LD: #{e.message.lines.first.strip}")
  end

  # Images
  doc.css("img").each do |img|
    error(page, "image missing alt text: #{img['src']}") if img["alt"].to_s.strip.empty?
  end

  # Links and assets
  ids = ids_in(File.join(DEST, page))
  refs = doc.css("a[href]").map { |a| [a["href"], :link] } +
         doc.css("img[src], script[src]").map { |el| [el["src"], :asset] } +
         doc.css('link[rel~="stylesheet"], link[rel~="icon"], link[rel="manifest"], link[rel="mask-icon"], link[rel="apple-touch-icon"]')
            .map { |el| [el["href"], :asset] }

  refs.each do |href, kind|
    href = href.to_s.strip
    next if href.empty? || href == "#"

    if href.start_with?("#")
      id = URI.decode_uri_component(href[1..])
      error(page, "anchor #{href} has no matching id") unless ids.include?(id)
      next
    end

    uri = URI.parse(href) rescue (next error(page, "malformed URL: #{href}"))
    next if uri.scheme && !%w[http https].include?(uri.scheme.downcase) # mailto:, tel:, ...

    if uri.host && uri.host.sub(/\Awww\./, "") != SITE_HOST
      external_links[href] << page
      next
    end

    if uri.host
      warning(page, "absolute link to own site, use a relative link: #{href}") if kind == :link
      href = uri.path.to_s.empty? ? "/" : uri.path
    end

    path = uri.path.to_s
    next if path.empty? # fragment/query only
    if kind == :link && path.match?(/\.(md|markdown|html)\z/) && path != "/feed.xml"
      next error(page, "link should use the clean URL (no .md/.html): #{href}")
    end

    target = path.start_with?("/") ? path : File.join(page_dir, path)
    file = resolve(target)
    next error(page, "broken #{kind}: #{href}") unless file

    if uri.fragment && file.end_with?(".html") && !ids_in(file).include?(URI.decode_uri_component(uri.fragment))
      error(page, "anchor ##{uri.fragment} not found on #{path}")
    end
  end
end

# --- External links (opt-in) -------------------------------------------------

def fetch_status(url, limit = 5)
  uri = URI(url)
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 10, read_timeout: 10) do |http|
    request = Net::HTTP::Get.new(uri, "User-Agent" => "Mozilla/5.0 (site link checker)")
    response = http.request(request)
    if response.is_a?(Net::HTTPRedirection) && limit.positive?
      return fetch_status(URI.join(url, response["location"]).to_s, limit - 1)
    end
    response.code.to_i
  end
end

if external
  puts "Checking #{external_links.size} external links..."
  queue = Queue.new
  external_links.each_key { |url| queue << url }
  results = {}
  Array.new(8) do
    Thread.new do
      while (url = (queue.pop(true) rescue nil))
        results[url] = begin
          fetch_status(url)
        rescue StandardError => e
          e.class.name
        end
      end
    end
  end.each(&:join)

  results.sort.each do |url, status|
    next if status.is_a?(Integer) && status < 300
    where = external_links[url].to_a.join(", ")
    msg = "#{url} -> #{status}"
    soft = EXTERNAL_SOFT_FAILS.include?(status) || (status.is_a?(Integer) && status < 400) # too many redirects
    soft ? warning(where, msg) : error(where, msg)
  end
else
  puts "Skipping #{external_links.size} external links (use --external to check)."
end

# --- Report ------------------------------------------------------------------

puts "Checked #{pages.size} pages."
unless @warnings.empty?
  puts "\n#{@warnings.size} warning(s):"
  @warnings.each { |w| puts "  ! #{w}" }
end
if @errors.empty?
  puts "\nAll checks passed."
else
  puts "\n#{@errors.size} error(s):"
  @errors.each { |e| puts "  x #{e}" }
  exit 1
end
