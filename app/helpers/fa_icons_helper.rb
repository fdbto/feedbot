module FaIconsHelper
  def fa(*params)
    opts = params.extract_options!
    names = params.map { |param| param.to_s.gsub(/_/, '-') }
    fa_icon names, opts
  end
end
