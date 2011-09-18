header do
  logo :players => "image", :image => "images/logo_and_tagline.png" #, :width => 250
end
divider
body do
  chart_list :id => :chart_list do
    link_group :text => "Viewers"
    chart_link :id => "viewer_accumulation", :text => "Viewer Accumulation"
    chart_link :id => "new_viewers_per_month", :text => "New Viewers/Month"
    link_group :text => "Codecasts"
    chart_link :id => "new_codecasts_per_month", :text => "New Codecasts/Month"
    link_group :text => "Licenses"
    chart_link :id => "new_licenses_per_month", :text => "New Licenses/Month"
    chart_link :id => "license_accumulation", :text => "License Accumulation"
    chart_link :id => "licenses_per_codecast", :text => "License/Codecast"
    link_group :text => "Viewings/Downloads"
    chart_link :id => "new_viewings_per_month", :text => "New Viewings/Month"
    chart_link :id => "viewing_accumulation", :text => "Viewing Accumulation"
    chart_link :id => "new_downloads_per_month", :text => "New Downloads/Month"
    chart_link :id => "download_accumulation", :text => "Download Accumulation"
    link_group :text => "Finances"
    chart_link :id => "revenue_per_month", :text => "Revenue/Month"
    chart_link :id => "revenue_accumulation", :text => "Revenue Accumulation"
    chart_link :id => "paypal_fee_accumulation", :text => "Paypal Fee Accumulation"
    chart_link :id => "revenue_per_codecast", :text => "Revenue/Codecast"
    chart_link :id => "revenue_per_month_per_codecast", :text => "Revenue/Codecast/Month"
    chart_link :id => "e1_revenue_per_month", :text => "E1 Revenue/Month"
    chart_link :id => "e2_revenue_per_month", :text => "E2 Revenue/Month"
    chart_link :id => "e3_revenue_per_month", :text => "E3 Revenue/Month"
    chart_link :id => "e4_revenue_per_month", :text => "E4 Revenue/Month"
    chart_link :id => "e5_revenue_per_month", :text => "E5 Revenue/Month"
    chart_link :id => "e6_1_revenue_per_month", :text => "E6-1 Revenue/Month"
    chart_link :id => "e6_2_revenue_per_month", :text => "E6-2 Revenue/Month"
  end
  chart_frame :id => :chart_frame do
    para :text => "Your graph is loading..."
  end
end


