header do
  logo :players => "image", :image => "images/logo_and_tagline.png" #, :width => 250
end
divider
body do
  chart_list :id => :chart_list do
    chart_link :id => "viewer_history", :text => "Viewer History"
    chart_link :id => "codecast_history", :text => "Codecast History"
    chart_link :id => "license_history", :text => "License History"
    chart_link :id => "payment_history", :text => "Payment History"
    chart_link :id => "viewing_history", :text => "Viewing History"
    chart_link :id => "download_history", :text => "Download History"
  end
  chart_frame :id => :chart_frame do
    para :text => "Your graph is loading..."
  end
end


