module NavigationHelper

  def collapsible_links_partial_path
    if user_signed_in?
      'layouts/navigation/collapsible_elements/_signed_in_links.html.erb'
    else
      'layouts/navigation/collapsible_elements/_non_signed_in_links.html.erb'
    end
  end
  
end
