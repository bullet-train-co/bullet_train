module BreadcrumbsHelper
  # determine whether we should display a breadcrumb item as a label or a link.
  def breadcrumb_link_to(label, path, options = {})
    # if the user passed in a string (e.g. called *_path) use that, otherwise convert the passed object or array
    # (e.g. [:account, :scaffolding, @thing]) to a string path before comparing to the current request.
    path = path.is_a?(String) ? path : main_app.url_for(path)

    # if we're already on the page the breadcrumb would link to, just show a label. otherwise, show a link.
    path == request.path ? label : link_to(label, path, options)
  end

  def account_controller_name_with_namespace
    params[:controller].gsub(/^account\//, '')
  end

  def breadcrumbs
    begin
      # try to render the new style of breadcrumbs.
      render 'account/shared/breadcrumbs'
    # however, it might throw an error if all the files aren't in the right place yet.
    rescue ActionView::Template::Error => error
      # if we caught a template error because a partial was missing, fall back to the old breadcrumb system.
      if error.to_s.include?("Missing partial")
        render 'layouts/account/breadcrumbs'
      elsif
        # otherwise, re-raise the error so the developer can see what they've done wrong.
        raise error
      end
    end
  end
end
