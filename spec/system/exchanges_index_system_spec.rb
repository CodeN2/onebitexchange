require 'rails_helper'

RSpec.describe "Exchange Currency Process", :type => :system, js: true do
  it "exchange value" do
    visit '/'
    within("#exchange_form") do
      select('EUR', from: 'source_currency')
      select('USD', from: 'target_currency')
      fill_in 'amount', with: '10'
    end
    # click_button 'CONVERTER'

    # save_and_open_page
    # expect(page).to have_content("value")
  end

  it "exchange value with bitcoin" do
    visit '/'
    within("#exchange_form") do
      select('BTC', from: 'source_currency')
      select('USD', from: 'target_currency')
      fill_in 'amount', with: '10'
    end
  end
end