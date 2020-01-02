require "rails_helper"

RSpec.describe "Notifications", type: :feature do
  # Key input variables:
  #
  # 1. Using a zip file vs answering questions manually
  # 2. Pre or Post Brexit
  # 3. Specifying exact ingredients, ingredient range or a frame formulation
  # 4. Multi-item product or single item product
  # 5. Contains nanomaterials or not
  # 6. Zip file: contains ingredients or ingredients missing


  # Dependent flows:
  #
  # 1.  Is a zip file required?
  # 2.  Is the user required to name each item?
  # 3.  Are details about how multi-items are used together required?
  # 4.  Are product images required?
  # 5.  Is an ingredient list upload required?
  # 6.  Is user required to select a frame formulation?
  # 7.  Are details about nanomaterials required?
  # 8.  Is the user required to answer questions about pH of items?
  # 9.  Is user required to say if product is for under-3s?
  # 10. Is user required to say if product is imported?
  # 11. Is user required to say if product contains a hair dye?

  let(:responsible_person) { create(:responsible_person_with_user) }

  before do
    sign_in_as_member_of_responsible_person(responsible_person)
  end


  # ---- ZIP file, pre-Brexit ------

  # scenario "Using a zip file, pre-Brexit, exact ingredients, single item, no nanomaterials" do
  #   # TODO
  # end

  # scenario "Using a zip file, pre-Brexit, ingredient ranges, single item, no nanomaterials" do
  #   # TODO
  # end

  # scenario "Using a zip file, pre-Brexit, frame formulation, single item, no nanomaterials" do
  #   # TODO
  # end

  # scenario "Using a zip file, pre-Brexit, exact ingredients (missing), single item, no nanomaterials" do
  #   # TODO
  # end

  # scenario "Using a zip file, pre-Brexit, ingredient ranges (missing), single item, no nanomaterials" do
  #   # TODO
  # end

  # scenario "Using a zip file, pre-Brexit, exact ingredients, multi-item, no nanomaterials" do
  #   # TODO
  # end

  # scenario "Using a zip file, pre-Brexit, exact ingredients, single item, with nanomaterials" do
  #   # TODO
  # end

  # scenario "Using a zip file, pre-Brexit, exact ingredients, multi-item, each with nanomaterials" do
  #   # TODO
  # end


  # ---- ZIP file, post-Brexit ------

  # scenario "Using a zip file, post-Brexit" do
  #  # Not currently allowed: user sees a message prompting manual journey
  # end



  # ----- Manual, Pre-Brexit ---------

  scenario "Manual, pre-Brexit, exact ingredients, single item, no nanomaterials" do
    visit new_responsible_person_add_notification_path(responsible_person)

    expect_to_be_on_was_eu_notified_about_products_page
    answer_was_eu_notified_with "Yes"

    expect_to_be_on_do_you_have_the_zip_files_page
    answer_do_you_have_zip_files_with "No, I’ll enter information manually"

    expect_to_be_on_was_product_notified_before_brexit_page
    answer_was_product_notified_before_brexit_with "Yes"

    expect_to_be_on_what_is_product_called_page
    answer_product_name_with "SkinSoft tangerine shampoo"

    expect_to_be_on_internal_reference_page
    answer_do_you_want_to_give_an_internal_reference_with "No"

    expect_to_be_on_was_product_imported_page
    answer_was_product_imported_with "No, it is manufactured in the UK"

    expect_to_be_on_multi_item_kits_page
    answer_is_product_multi_item_kit_with "No, this is a single product"

    expect_to_be_on_is_item_available_in_shades_page
    answer_is_item_available_in_shades_with "No"

    expect_to_be_on_physical_form_of_item_page
    answer_what_is_physical_form_of_item_with "Liquid"

    expect_to_be_on_does_item_contain_cmrs_page
    answer_does_item_contain_cmrs_with "No"

    expect_to_be_on_does_item_contain_nanomaterial_page
    answer_does_item_contain_nanomaterials_with "No"

    expect_to_be_on_item_category_page
    answer_item_category_with "Hair and scalp products"

    expect_to_be_on_item_subcategoy_page(category: "hair and scalp products")
    answer_item_subcategory_with "Hair and scalp care and cleansing products"

    expect_to_be_on_item_sub_subcategory_page(subcategory: "hair and scalp care and cleansing products")
    answer_item_sub_subcategory_with "Shampoo"

    expect_to_be_on_formulation_method_page
    answer_how_do_you_want_to_give_formulation_with "List ingredients and their exact concentration"

    expect_to_be_on_upload_ingredients_page
    upload_ingredients_pdf

    expect_to_be_on_what_is_ph_range_of_product_page
    answer_what_is_ph_range_of_product_with "The minimum pH is 3 or higher, and the maximum pH is 10 or lower"

    expect_to_be_on_check_your_answers_page(product_name: "SkinSoft tangerine shampoo")

    expect_check_your_answers_page_to_contain(
      product_name: "SkinSoft tangerine shampoo",
      imported: "No",
      number_of_components: "1",
      shades: "None",
      contains_cmrs: "No",
      nanomaterials: "None",
      category: "Hair and scalp products",
      subcategory: "Hair and scalp care and cleansing products",
      sub_subcategory: "Shampoo",
      formulation_given_as: "Exact concentration",
      physical_form: "Liquid",
      ph: "Between 3 and 10",
    )
    click_button "Accept and submit the cosmetic product notification"

    expect_to_be_on_your_cosmetic_products_page
    expect_to_see_message "SkinSoft tangerine shampoo notification submitted"
  end

  scenario "Manual, pre-Brexit, ingredient ranges, single item, no nanomaterials" do
    visit new_responsible_person_add_notification_path(responsible_person)

    expect_to_be_on_was_eu_notified_about_products_page
    answer_was_eu_notified_with "Yes"

    expect_to_be_on_do_you_have_the_zip_files_page
    answer_do_you_have_zip_files_with "No, I’ll enter information manually"

    expect_to_be_on_was_product_notified_before_brexit_page
    answer_was_product_notified_before_brexit_with "Yes"

    expect_to_be_on_what_is_product_called_page
    answer_product_name_with "SkinSoft tangerine shampoo"

    expect_to_be_on_internal_reference_page
    answer_do_you_want_to_give_an_internal_reference_with "No"

    expect_to_be_on_was_product_imported_page
    answer_was_product_imported_with "No, it is manufactured in the UK"

    expect_to_be_on_multi_item_kits_page
    answer_is_product_multi_item_kit_with "No, this is a single product"

    expect_to_be_on_is_item_available_in_shades_page
    answer_is_item_available_in_shades_with "No"

    expect_to_be_on_physical_form_of_item_page
    answer_what_is_physical_form_of_item_with "Liquid"

    expect_to_be_on_does_item_contain_cmrs_page
    answer_does_item_contain_cmrs_with "No"

    expect_to_be_on_does_item_contain_nanomaterial_page
    answer_does_item_contain_nanomaterials_with "No"

    expect_to_be_on_item_category_page
    answer_item_category_with "Hair and scalp products"

    expect_to_be_on_item_subcategoy_page(category: "hair and scalp products")
    answer_item_subcategory_with "Hair and scalp care and cleansing products"

    expect_to_be_on_item_sub_subcategory_page(subcategory: "hair and scalp care and cleansing products")
    answer_item_sub_subcategory_with "Shampoo"

    expect_to_be_on_formulation_method_page
    answer_how_do_you_want_to_give_formulation_with "List ingredients and their concentration range"

    expect_to_be_on_upload_ingredients_page
    upload_ingredients_pdf

    expect_to_be_on_what_is_ph_range_of_product_page
    answer_what_is_ph_range_of_product_with "The minimum pH is 3 or higher, and the maximum pH is 10 or lower"

    expect_to_be_on_check_your_answers_page(product_name: "SkinSoft tangerine shampoo")

    expect_check_your_answers_page_to_contain(
      product_name: "SkinSoft tangerine shampoo",
      imported: "No",
      number_of_components: "1",
      shades: "None",
      contains_cmrs: "No",
      nanomaterials: "None",
      category: "Hair and scalp products",
      subcategory: "Hair and scalp care and cleansing products",
      sub_subcategory: "Shampoo",
      formulation_given_as: "Concentration ranges",
      physical_form: "Liquid",
      ph: "Between 3 and 10",
    )
    click_button "Accept and submit the cosmetic product notification"

    expect_to_be_on_your_cosmetic_products_page
    expect_to_see_message "SkinSoft tangerine shampoo notification submitted"
  end

  scenario "Manual, pre-Brexit, frame formulation, single item, no nanomaterials" do
    visit new_responsible_person_add_notification_path(responsible_person)

    expect_to_be_on_was_eu_notified_about_products_page
    answer_was_eu_notified_with "Yes"

    expect_to_be_on_do_you_have_the_zip_files_page
    answer_do_you_have_zip_files_with "No, I’ll enter information manually"

    expect_to_be_on_was_product_notified_before_brexit_page
    answer_was_product_notified_before_brexit_with "Yes"

    expect_to_be_on_what_is_product_called_page
    answer_product_name_with "SkinSoft deep blue mouthwash"

    expect_to_be_on_internal_reference_page
    answer_do_you_want_to_give_an_internal_reference_with "No"

    expect_to_be_on_was_product_imported_page
    answer_was_product_imported_with "No, it is manufactured in the UK"

    expect_to_be_on_multi_item_kits_page
    answer_is_product_multi_item_kit_with "No, this is a single product"

    expect_to_be_on_is_item_available_in_shades_page
    answer_is_item_available_in_shades_with "No"

    expect_to_be_on_physical_form_of_item_page
    answer_what_is_physical_form_of_item_with "Liquid"

    expect_to_be_on_does_item_contain_cmrs_page
    answer_does_item_contain_cmrs_with "No"

    expect_to_be_on_does_item_contain_nanomaterial_page
    answer_does_item_contain_nanomaterials_with "No"

    expect_to_be_on_item_category_page
    answer_item_category_with "Oral hygiene products"

    expect_to_be_on_item_subcategoy_page(category: "oral hygiene products")
    answer_item_subcategory_with "Mouth wash / breath spray"

    expect_to_be_on_item_sub_subcategory_page(subcategory: "mouth wash / breath spray")
    answer_item_sub_subcategory_with "Mouth wash"

    expect_to_be_on_formulation_method_page
    answer_how_do_you_want_to_give_formulation_with "Choose a predefined frame formulation"

    expect_to_be_on_frame_formulation_select_page
    give_frame_formulation_as "Mouthwash"

    expect_to_be_on_what_is_ph_range_of_product_page
    answer_what_is_ph_range_of_product_with "It does not have a pH"

    expect_to_be_on_check_your_answers_page(product_name: "SkinSoft deep blue mouthwash")

    expect_check_your_answers_page_to_contain(
      product_name: "SkinSoft deep blue mouthwash",
      imported: "No",
      number_of_components: "1",
      shades: "None",
      contains_cmrs: "No",
      nanomaterials: "None",
      category: "Oral hygiene products",
      subcategory: "Mouth wash / breath spray",
      sub_subcategory: "Mouth wash",
      formulation_given_as: "Frame formulation",
      physical_form: "Liquid",
      ph: "No pH",
    )
    click_button "Accept and submit the cosmetic product notification"

    expect_to_be_on_your_cosmetic_products_page
    expect_to_see_message "SkinSoft deep blue mouthwash notification submitted"
  end

  scenario "Manual, pre-Brexit, frame formulation, multi-item, no nanomaterials" do
    visit new_responsible_person_add_notification_path(responsible_person)

    expect_to_be_on_was_eu_notified_about_products_page
    answer_was_eu_notified_with "Yes"

    expect_to_be_on_do_you_have_the_zip_files_page
    answer_do_you_have_zip_files_with "No, I’ll enter information manually"

    expect_to_be_on_was_product_notified_before_brexit_page
    answer_was_product_notified_before_brexit_with "Yes"

    expect_to_be_on_what_is_product_called_page
    answer_product_name_with "SkinSoft strawberry blonde hair dye"

    expect_to_be_on_internal_reference_page
    answer_do_you_want_to_give_an_internal_reference_with "No"

    expect_to_be_on_was_product_imported_page
    answer_was_product_imported_with "No, it is manufactured in the UK"

    expect_to_be_on_multi_item_kits_page
    answer_is_product_multi_item_kit_with "Yes"

    expect_to_be_on_how_are_items_used_together_page
    answer_how_are_items_used_together_with "Used in a particular order"

    expect_to_be_on_kit_items_page
    add_an_item

    expect_to_be_on_what_is_item_called_page
    answer_item_name_with "SkinSoft strawberry blonde hair colourant"

    expect_to_be_on_is_item_available_in_shades_page(item_name: "SkinSoft strawberry blonde hair colourant")
    answer_is_item_available_in_shades_with "No", item_name: "SkinSoft strawberry blonde hair colourant"

    expect_to_be_on_physical_form_of_item_page(item_name: "SkinSoft strawberry blonde hair colourant")
    answer_what_is_physical_form_of_item_with "Liquid", item_name: "SkinSoft strawberry blonde hair colourant"

    expect_to_be_on_does_item_contain_cmrs_page
    answer_does_item_contain_cmrs_with "No", item_name: "SkinSoft strawberry blonde hair colourant"

    expect_to_be_on_does_item_contain_nanomaterial_page
    answer_does_item_contain_nanomaterials_with "No", item_name: "SkinSoft strawberry blonde hair colourant"

    expect_to_be_on_item_category_page
    answer_item_category_with "Hair and scalp products"

    expect_to_be_on_item_subcategoy_page(category: "hair and scalp products", item_name: "SkinSoft strawberry blonde hair colourant")
    answer_item_subcategory_with "Hair colouring products"

    expect_to_be_on_item_sub_subcategory_page(subcategory: "hair colouring products", item_name: "SkinSoft strawberry blonde hair colourant")
    answer_item_sub_subcategory_with "Oxidative hair colour products"

    expect_to_be_on_formulation_method_page item_name: "SkinSoft strawberry blonde hair colourant"
    answer_how_do_you_want_to_give_formulation_with("Choose a predefined frame formulation", item_name: "SkinSoft strawberry blonde hair colourant")

    expect_to_be_on_frame_formulation_select_page
    give_frame_formulation_as "Hair Colorant (Permanent, Oxidative Type) - Type 1 : Two Components - Colorant Part"

    expect_to_be_on_what_is_ph_range_of_product_page
    answer_what_is_ph_range_of_product_with "It does not have a pH"

    expect_to_be_on_kit_items_page
    add_an_item

    expect_to_be_on_what_is_item_called_page
    answer_item_name_with "SkinSoft strawberry blonde hair fixer"

    expect_to_be_on_is_item_available_in_shades_page(item_name: "SkinSoft strawberry blonde hair fixer")
    answer_is_item_available_in_shades_with "No", item_name: "SkinSoft strawberry blonde hair fixer"

    expect_to_be_on_physical_form_of_item_page item_name: "SkinSoft strawberry blonde hair fixer"
    answer_what_is_physical_form_of_item_with "Liquid", item_name: "SkinSoft strawberry blonde hair fixer"

    expect_to_be_on_does_item_contain_cmrs_page
    answer_does_item_contain_cmrs_with "No", item_name: "SkinSoft strawberry blonde hair fixer"

    expect_to_be_on_does_item_contain_nanomaterial_page
    answer_does_item_contain_nanomaterials_with "No", item_name: "SkinSoft strawberry blonde hair fixer"

    expect_to_be_on_item_category_page
    answer_item_category_with "Hair and scalp products"

    expect_to_be_on_item_subcategoy_page(category: "hair and scalp products", item_name: "SkinSoft strawberry blonde hair fixer")
    answer_item_subcategory_with "Hair colouring products"

    expect_to_be_on_item_sub_subcategory_page(subcategory: "hair colouring products", item_name: "SkinSoft strawberry blonde hair fixer")
    answer_item_sub_subcategory_with "Oxidative hair colour products"

    expect_to_be_on_formulation_method_page item_name: "SkinSoft strawberry blonde hair fixer"
    answer_how_do_you_want_to_give_formulation_with "Choose a predefined frame formulation", item_name: "SkinSoft strawberry blonde hair fixer"

    expect_to_be_on_frame_formulation_select_page
    give_frame_formulation_as "Hair Colorant (Permanent, Oxidative Type) - Type 1 : Two Or Three Components - Oxidative Part"

    expect_to_be_on_what_is_ph_range_of_product_page
    answer_what_is_ph_range_of_product_with "It does not have a pH"

    expect_to_be_on_kit_items_page
    click_button "Continue"

    expect_to_be_on_check_your_answers_page(product_name: "SkinSoft strawberry blonde hair dye")

    expect_check_your_answers_page_for_kit_items_to_contain(
      product_name: "SkinSoft strawberry blonde hair dye",
      imported: "No",
      number_of_components: "2",
      components_mixed: "No",
      kit_items: [
        {
          name: "SkinSoft strawberry blonde hair colourant",
          shades: "None",
          contains_cmrs: "No",
          nanomaterials: "None",
          category: "Hair and scalp products",
          subcategory: "Hair colouring product",
          sub_subcategory: "Oxidative hair colour products",
          formulation_given_as: "Frame formulation",
          physical_form: "Liquid",
          ph: "No pH",
        },
        {
          name: "SkinSoft strawberry blonde hair fixer",
          shades: "None",
          contains_cmrs: "No",
          nanomaterials: "None",
          category: "Hair and scalp products",
          subcategory: "Hair colouring product",
          sub_subcategory: "Oxidative hair colour products",
          formulation_given_as: "Frame formulation",
          physical_form: "Liquid",
          ph: "No pH",
        },
      ],
    )
    click_button "Accept and submit the cosmetic product notification"

    expect_to_be_on_your_cosmetic_products_page
    expect_to_see_message "SkinSoft strawberry blonde hair dye notification submitted"
  end

  # scenario "Manual, pre-Brexit, frame formulation, single item, with nanomaterials" do
  #   # TODO
  # end

  # scenario "Manual, pre-Brexit, frame formulation, multi-item, each with nanomaterials" do
  #   # TODO
  # end



  # ----- Manual, Post-Brexit --------

  # scenario "Manual, post-Brexit, exact ingredients, single item, no nanomaterials" do
  #   # TODO
  # end

  # scenario "Manual, post-Brexit, ingredient ranges, single item, no nanomaterials" do
  #   # TODO
  # end

  # scenario "Manual, post-Brexit, frame formulation, single item, no nanomaterials" do
  #   # TODO
  # end

  # scenario "Manual, post-Brexit, frame formulation (with poisonous ingredients), single item, no nanomaterials" do
  #   # TODO
  # end

  # scenario "Manual, post-Brexit, frame formulation, multi-item, no nanomaterials" do
  #   # TODO
  # end

  # scenario "Manual, post-Brexit, frame formulation, single item, with nanomaterials" do
  #   # TODO
  # end

  # scenario "Manual, post-Brexit, frame formulation, multi-item, each with nanomaterials" do
  #   # TODO
  # end
end
