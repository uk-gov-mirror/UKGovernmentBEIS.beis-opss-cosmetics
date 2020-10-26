module NotificationTriggerRules
  extend ActiveSupport::Concern

  included do
    TRIGGER_RULES_QUESTION = {
      please_specify_the_percentage_weight_of_ethanol: "please_specify_the_percentage_weight_of_ethanol",
      please_specify_the_percentage_weight_of_isopropanol: "please_specify_the_percentage_weight_of_isopropanol",
      please_specify_the_inci_name_and_concentration_of_the_antidandruff_agents_if_antidandruff_agents_are_not_present_in_the_cosmetic_product_then_not_applicable_must_be_checked: "please_specify_the_inci_name_and_concentration_of_the_antidandruff_agents_if_antidandruff_agents_are_not_present_in_the_cosmetic_product_then_not_applicable_must_be_checked",
      please_specify_the_inci_name_and_concentration_of_the_antihair_loss_agents_if_antihair_loss_agents_are_not_present_in_the_cosmetic_product_then_not_applicable_must_be_checked: "please_specify_the_inci_name_and_concentration_of_the_antihair_loss_agents_if_antihair_loss_agents_are_not_present_in_the_cosmetic_product_then_not_applicable_must_be_checked",
      please_specify_the_inci_name_and_concentration_of_the_antipigmenting_and_depigmenting_agents_if_antipigmenting_and_depigmenting_agents_are_not_present_in_the_cosmetic_product_then_not_applicable_must_be_checked: "please_specify_the_inci_name_and_concentration_of_the_antipigmenting_and_depigmenting_agents_if_antipigmenting_and_depigmenting_agents_are_not_present_in_the_cosmetic_product_then_not_applicable_must_be_checked",
      please_specify_the_inci_name_and_concentration_of_chemical_exfoliating_agents_if_chemical_exfoliating_agents_are_not_present_in_the_cosmetic_product_then_not_applicable_must_be_checked: "please_specify_the_inci_name_and_concentration_of_chemical_exfoliating_agents_if_chemical_exfoliating_agents_are_not_present_in_the_cosmetic_product_then_not_applicable_must_be_checked",
      please_specify_the_exact_content_of_vitamin_a_or_its_derivatives_for_the_whole_product_if_the_level_of_vitamin_a_or_any_of_its_derivatives_does_not_exceed_020_calculated_as_retinol_or_if_the_amount_does_not_exceed_009_grams_calculated_as_retinol_or_if_vitamin_a_or_any_of_its_derivatives_are_not_present_in_the_product_then_not_applicable_must_be_checked: "please_specify_the_exact_content_of_vitamin_a_or_its_derivatives_for_the_whole_product_if_the_level_of_vitamin_a_or_any_of_its_derivatives_does_not_exceed_020_calculated_as_retinol_or_if_the_amount_does_not_exceed_009_grams_calculated_as_retinol_or_if_vitamin_a_or_any_of_its_derivatives_are_not_present_in_the_product_then_not_applicable_must_be_checked",
      please_specify_the_inci_name_and_the_concentration_of_xanthine_derivatives_eg_caffeine_theophylline_theobromine_plant_extracts_containing_xanthine_derivatives_eg_paulinia_cupana_guarana_extractspowders_if_xanthine_derivatives_are_not_present_or_present_below_05_in_the_cosmetic_product_then_not_applicable_must_be_checked: "please_specify_the_inci_name_and_the_concentration_of_xanthine_derivatives_eg_caffeine_theophylline_theobromine_plant_extracts_containing_xanthine_derivatives_eg_paulinia_cupana_guarana_extractspowders_if_xanthine_derivatives_are_not_present_or_present_below_05_in_the_cosmetic_product_then_not_applicable_must_be_checked",
      please_specify_the_inci_name_and_concentration_of_the_cationic_surfactants_with_two_or_more_chain_lengths_below_c12_if_the_surfactant_is_used_for_non_preservative_purpose_if_cationic_surfactants_with_two_or_more_chain_lengths_below_c12_are_not_present_in_the_product_then_not_applicable_must_be_checked: "please_specify_the_inci_name_and_concentration_of_the_cationic_surfactants_with_two_or_more_chain_lengths_below_c12_if_the_surfactant_is_used_for_non_preservative_purpose_if_cationic_surfactants_with_two_or_more_chain_lengths_below_c12_are_not_present_in_the_product_then_not_applicable_must_be_checked",
      please_specify_the_inci_name_and_concentration_of_each_propellant_if_propellants_are_not_present_in_the_product_then_not_applicable_must_be_checked: "please_specify_the_inci_name_and_concentration_of_each_propellant_if_propellants_are_not_present_in_the_product_then_not_applicable_must_be_checked",
      please_specify_the_concentration_of_hydrogen_peroxide_if_hydrogen_peroxide_is_not_present_in_the_product_then_not_applicable_must_be_checked_: "please_specify_the_concentration_of_hydrogen_peroxide_if_hydrogen_peroxide_is_not_present_in_the_product_then_not_applicable_must_be_checked_",
      please_specify_the_inci_name_and_the_concentration_of_the_compounds_that_release_hydrogen_peroxide_if_compounds_releasing_hydrogen_peroxide_are_not_present_in_the_product_then_not_applicable_must_be_checked: "please_specify_the_inci_name_and_the_concentration_of_the_compounds_that_release_hydrogen_peroxide_if_compounds_releasing_hydrogen_peroxide_are_not_present_in_the_product_then_not_applicable_must_be_checked",
      please_specify_the_inci_name_and_concentration_of_each_reducing_agent_if_reducing_agents_are_not_present_in_the_product_then_not_applicable_must_be_checked: "please_specify_the_inci_name_and_concentration_of_each_reducing_agent_if_reducing_agents_are_not_present_in_the_product_then_not_applicable_must_be_checked",
      please_specify_the_inci_name_and_concentration_of_each_persulfate_if_persulfates_are_not_present_in_the_product_then_not_applicable_must_be_checked: "please_specify_the_inci_name_and_concentration_of_each_persulfate_if_persulfates_are_not_present_in_the_product_then_not_applicable_must_be_checked",
      please_specify_the_inci_name_and_concentration_of_each_straightening_agent_if_straightening_agents_are_not_present_in_the_product_then_not_applicable_must_be_checked: "please_specify_the_inci_name_and_concentration_of_each_straightening_agent_if_straightening_agents_are_not_present_in_the_product_then_not_applicable_must_be_checked",
      please_indicate_the_total_concentration_of_inorganic_sodium_salts_if_inorganic_sodium_salts_are_not_present_in_the_product_then_not_applicable_must_be_checked: "please_indicate_the_total_concentration_of_inorganic_sodium_salts_if_inorganic_sodium_salts_are_not_present_in_the_product_then_not_applicable_must_be_checked",
      please_indicate_the_concentration_of_fluoride_compounds_calculated_as_fluorine_if_fluoride_compounds_are_not_present_in_the_product_then_not_applicable_must_be_checked: "please_indicate_the_concentration_of_fluoride_compounds_calculated_as_fluorine_if_fluoride_compounds_are_not_present_in_the_product_then_not_applicable_must_be_checked",
      is_the_ph_of_the_component_lower_than_3_or_higher_than_10: "is_the_ph_of_the_component_lower_than_3_or_higher_than_10",
      please_indicate_the_total_level_of_essential_oils_camphor_menthol_or_eucalyptol_if_essential_oils_camphor_menthol_or_eucalyptol_are_not_present_in_the_product_or_if_the_level_of_essential_oils_camphor_menthol_or_eucalyptol_does_not_exceed_05_then_not_applicable_must_be_checked: "please_indicate_the_total_level_of_essential_oils_camphor_menthol_or_eucalyptol_if_essential_oils_camphor_menthol_or_eucalyptol_are_not_present_in_the_product_or_if_the_level_of_essential_oils_camphor_menthol_or_eucalyptol_does_not_exceed_05_then_not_applicable_must_be_checked",
      please_indicate_the_name_and_the_quantity_of_each_essential_oil_camphor_menthol_or_eucalyptol_if_no_individual_essential_oil_camphor_menthol_or_eucalyptol_are_present_with_a_level_higher_than_05_015_in_case_of_camphor_then_not_applicable_must_be_checked: "please_indicate_the_name_and_the_quantity_of_each_essential_oil_camphor_menthol_or_eucalyptol_if_no_individual_essential_oil_camphor_menthol_or_eucalyptol_are_present_with_a_level_higher_than_05_015_in_case_of_camphor_then_not_applicable_must_be_checked",
      please_indicate_the_total_concentration_of_inorganic_sodium_salts: "please_indicate_the_total_concentration_of_inorganic_sodium_salts",
      please_indicate_the_ph_of_the_hair_dye_component: "please_indicate_the_ph_of_the_hair_dye_component",
      please_indicate_the_ph_of_the_mixed_hair_dye_product: "please_indicate_the_ph_of_the_mixed_hair_dye_product",
      please_indicate_the_ph: "please_indicate_the_ph",
      please_indicate_the_ph_of_the_mixed_product_: "please_indicate_the_ph_of_the_mixed_product_",
      do_the_components_of_the_product_need_to_be_mixed: "do_the_components_of_the_product_need_to_be_mixed",
      please_indicate_the_inci_name_and_concentration_of_each_alkaline_agent_including_ammonium_hydroxide_liberators: "please_indicate_the_inci_name_and_concentration_of_each_alkaline_agent_including_ammonium_hydroxide_liberators",
    }.freeze

    TRIGGER_RULES_QUESTION_ELEMENT = {
      ethanol: "ethanol",
      propanol: "propanol",
      inciname: "inciname",
      incivalue: "incivalue",
      value: "value",
      ph: "ph",
      concentration: "concentration",
      minrangevalue: "minrangevalue",
      maxrangevalue: "maxrangevalue",
    }.freeze
  end
end
