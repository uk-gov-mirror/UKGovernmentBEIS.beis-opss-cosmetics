module NotificationCategories
  extend ActiveSupport::Concern

  included do
    enum category: {
      skin_products: "skin_products",
      skin_care_products: "skin_care_products",
      face_care_products_other_than_face_mask: "face_care_products_other_than_face_mask",
      face_mask: "face_mask",
      eye_contour_products: "eye_contour_products",
      lip_care_products: "lip_care_products",
      hand_care_products: "hand_care_products",
      foot_care_products: "foot_care_products",
      body_care_products: "body_care_products",
      external_intimate_care_products: "external_intimate_care_products",
      chemical_exfoliation_products: "chemical_exfoliation_products",
      mechanical_exfoliation_products: "mechanical_exfoliation_products",
      skin_lightening_products: "skin_lightening_products",
      other_skin_care_products: "other_skin_care_products",
      skin_cleansing_products: "skin_cleansing_products",
      soap_products: "soap_products",
      bath_shower_products: "bath_shower_products",
      makeup_remover_products: "makeup_remover_products",
      external_intimate_hygiene_products: "external_intimate_hygiene_products",
      other_skin_cleansing_products: "other_skin_cleansing_products",
      body_hair_removal_products: "body_hair_removal_products",
      chemical_depilatories: "chemical_depilatories",
      physical_epilation_products: "physical_epilation_products",
      other_body_hair_removal_products: "other_body_hair_removal_products",
      bleach_for_body_hair_products: "bleach_for_body_hair_products",
      bleach_for_body_hair: "bleach_for_body_hair",
      correction_of_body_odour_andor_perspiration: "correction_of_body_odour_andor_perspiration",
      products_with_antiperspirant_activity: "products_with_antiperspirant_activity",
      products_without_antiperspirant_activity: "products_without_antiperspirant_activity",
      shaving_and_pre_after_shaving_products: "shaving_and_pre_after_shaving_products",
      shaving_products: "shaving_products",
      pre_aftershaving_products: "pre_aftershaving_products",
      other_shaving_and_pre_after_shaving_products: "other_shaving_and_pre_after_shaving_products",
      makeup_products: "makeup_products",
      foundation: "foundation",
      concealer: "concealer",
      other_face_makeup_products: "other_face_makeup_products",
      mascara: "mascara",
      eye_shadow: "eye_shadow",
      eye_pencil: "eye_pencil",
      eye_liner: "eye_liner",
      other_eye_makeup_products: "other_eye_makeup_products",
      lip_stick: "lip_stick",
      lipstick_sealer: "lipstick_sealer",
      other_lip_makeup_products: "other_lip_makeup_products",
      body_or_face_paint_including_carneval_makeup: "body_or_face_paint_including_carneval_makeup",
      other_makeup_products: "other_makeup_products",
      perfumes: "perfumes",
      hydroalcoholic_perfumes: "hydroalcoholic_perfumes",
      non_hydroalcoholic_perfumes: "non_hydroalcoholic_perfumes",
      sun_and_selftanning_products: "sun_and_selftanning_products",
      before_and_after_sun_products: "before_and_after_sun_products",
      sun_protection_products: "sun_protection_products",
      selftanning_products: "selftanning_products",
      other_sun_and_selftanning_products: "other_sun_and_selftanning_products",
      other_skin_products: "other_skin_products",
      other_skin_products_child: "other_skin_products_child",
      hair_and_scalp_products: "hair_and_scalp_products",
      hair_and_scalp_care_and_cleansing_products: "hair_and_scalp_care_and_cleansing_products",
      shampoo: "shampoo",
      hair_conditioner: "hair_conditioner",
      scalp_and_hair_roots_care_products: "scalp_and_hair_roots_care_products",
      antidandruff_products: "antidandruff_products",
      antihairloss_products: "antihairloss_products",
      other_hair_and_scalp_care_and_cleansing_products: "other_hair_and_scalp_care_and_cleansing_products",
      hair_colouring_products: "hair_colouring_products",
      oxidative_hair_colour_products: "oxidative_hair_colour_products",
      nonoxidative_hair_colour_products: "nonoxidative_hair_colour_products",
      hair_bleaching_and_dye_remover_products: "hair_bleaching_and_dye_remover_products",
      other_hair_colouring_products: "other_hair_colouring_products",
      hair_styling_products: "hair_styling_products",
      products_for_temporary_hair_styling: "products_for_temporary_hair_styling",
      permanent_wave_products: "permanent_wave_products",
      hair_relaxer_straightener_products: "hair_relaxer_straightener_products",
      other_hair_styling_products: "other_hair_styling_products",
      other_hair_and_scalp_products: "other_hair_and_scalp_products",
      hair_sun_protection_products: "hair_sun_protection_products",
      other_hair_and_scalp_products_child: "other_hair_and_scalp_products_child",
      nail_and_cuticle_products: "nail_and_cuticle_products",
      nail_varnish_and_remover_products: "nail_varnish_and_remover_products",
      nail_varnish_nail_makeup: "nail_varnish_nail_makeup",
      nail_varnish_remover: "nail_varnish_remover",
      nail_varnish_thinner: "nail_varnish_thinner",
      nail_bleach: "nail_bleach",
      other_nail_varnish_and_remover_products: "other_nail_varnish_and_remover_products",
      nail_care_nail_hardener_products: "nail_care_nail_hardener_products",
      nail_care_products: "nail_care_products",
      nail_hardener: "nail_hardener",
      other_nail_care_nail_hardener_products: "other_nail_care_nail_hardener_products",
      nail_glue_remover_products: "nail_glue_remover_products",
      nail_glue_remover: "nail_glue_remover",
      other_nail_and_cuticle_products: "other_nail_and_cuticle_products",
      cuticle_remover_softener: "cuticle_remover_softener",
      nail_sculpting_products: "nail_sculpting_products",
      other_nail_and_cuticle_products_child: "other_nail_and_cuticle_products_child",
      oral_hygiene_products: "oral_hygiene_products",
      tooth_care_products: "tooth_care_products",
      toothpaste: "toothpaste",
      tooth_cleansing_powder_salt: "tooth_cleansing_powder_salt",
      other_tooth_care_products: "other_tooth_care_products",
      mouth_wash_breath_spray: "mouth_wash_breath_spray",
      mouth_wash: "mouth_wash",
      breath_spray: "breath_spray",
      other_mouth_wash_breath_spray_products: "other_mouth_wash_breath_spray_products",
      tooth_whiteners: "tooth_whiteners",
      tooth_whiteners_child: "tooth_whiteners_child",
      other_oral_hygiene_products: "other_oral_hygiene_products",
      other_oral_hygiene_products_child: "other_oral_hygiene_products_child",
    }, _prefix: :category

    PARENT_OF_CATEGORY = {
      skin_care_products: :skin_products,
      face_care_products_other_than_face_mask: :skin_care_products,
      face_mask: :skin_care_products,
      eye_contour_products: :skin_care_products,
      lip_care_products: :skin_care_products,
      hand_care_products: :skin_care_products,
      foot_care_products: :skin_care_products,
      body_care_products: :skin_care_products,
      external_intimate_care_products: :skin_care_products,
      chemical_exfoliation_products: :skin_care_products,
      mechanical_exfoliation_products: :skin_care_products,
      skin_lightening_products: :skin_care_products,
      other_skin_care_products: :skin_care_products,
      skin_cleansing_products: :skin_products,
      soap_products: :skin_cleansing_products,
      bath_shower_products: :skin_cleansing_products,
      makeup_remover_products: :skin_cleansing_products,
      external_intimate_hygiene_products: :skin_cleansing_products,
      other_skin_cleansing_products: :skin_cleansing_products,
      body_hair_removal_products: :skin_products,
      chemical_depilatories: :body_hair_removal_products,
      physical_epilation_products: :body_hair_removal_products,
      other_body_hair_removal_products: :body_hair_removal_products,
      bleach_for_body_hair_products: :skin_products,
      bleach_for_body_hair: :bleach_for_body_hair_products,
      correction_of_body_odour_andor_perspiration: :skin_products,
      products_with_antiperspirant_activity: :correction_of_body_odour_andor_perspiration,
      products_without_antiperspirant_activity: :correction_of_body_odour_andor_perspiration,
      shaving_and_pre_after_shaving_products: :skin_products,
      shaving_products: :shaving_and_pre_after_shaving_products,
      pre_aftershaving_products: :shaving_and_pre_after_shaving_products,
      other_shaving_and_pre_after_shaving_products: :shaving_and_pre_after_shaving_products,
      makeup_products: :skin_products,
      foundation: :makeup_products,
      concealer: :makeup_products,
      other_face_makeup_products: :makeup_products,
      mascara: :makeup_products,
      eye_shadow: :makeup_products,
      eye_pencil: :makeup_products,
      eye_liner: :makeup_products,
      other_eye_makeup_products: :makeup_products,
      lip_stick: :makeup_products,
      lipstick_sealer: :makeup_products,
      other_lip_makeup_products: :makeup_products,
      body_or_face_paint_including_carneval_makeup: :makeup_products,
      other_makeup_products: :makeup_products,
      perfumes: :skin_products,
      hydroalcoholic_perfumes: :perfumes,
      non_hydroalcoholic_perfumes: :perfumes,
      sun_and_selftanning_products: :skin_products,
      before_and_after_sun_products: :sun_and_selftanning_products,
      sun_protection_products: :sun_and_selftanning_products,
      selftanning_products: :sun_and_selftanning_products,
      other_sun_and_selftanning_products: :sun_and_selftanning_products,
      other_skin_products: :skin_products,
      other_skin_products_child: :other_skin_products,
      hair_and_scalp_care_and_cleansing_products: :hair_and_scalp_products,
      shampoo: :hair_and_scalp_care_and_cleansing_products,
      hair_conditioner: :hair_and_scalp_care_and_cleansing_products,
      scalp_and_hair_roots_care_products: :hair_and_scalp_care_and_cleansing_products,
      antidandruff_products: :hair_and_scalp_care_and_cleansing_products,
      antihairloss_products: :hair_and_scalp_care_and_cleansing_products,
      other_hair_and_scalp_care_and_cleansing_products: :hair_and_scalp_care_and_cleansing_products,
      hair_colouring_products: :hair_and_scalp_products,
      oxidative_hair_colour_products: :hair_colouring_products,
      nonoxidative_hair_colour_products: :hair_colouring_products,
      hair_bleaching_and_dye_remover_products: :hair_colouring_products,
      other_hair_colouring_products: :hair_colouring_products,
      hair_styling_products: :hair_and_scalp_products,
      products_for_temporary_hair_styling: :hair_styling_products,
      permanent_wave_products: :hair_styling_products,
      hair_relaxer_straightener_products: :hair_styling_products,
      other_hair_styling_products: :hair_styling_products,
      other_hair_and_scalp_products: :hair_and_scalp_products,
      hair_sun_protection_products: :other_hair_and_scalp_products,
      other_hair_and_scalp_products_child: :other_hair_and_scalp_products,
      nail_varnish_and_remover_products: :nail_and_cuticle_products,
      nail_varnish_nail_makeup: :nail_varnish_and_remover_products,
      nail_varnish_remover: :nail_varnish_and_remover_products,
      nail_varnish_thinner: :nail_varnish_and_remover_products,
      nail_bleach: :nail_varnish_and_remover_products,
      other_nail_varnish_and_remover_products: :nail_varnish_and_remover_products,
      nail_care_nail_hardener_products: :nail_and_cuticle_products,
      nail_care_products: :nail_care_nail_hardener_products,
      nail_hardener: :nail_care_nail_hardener_products,
      other_nail_care_nail_hardener_products: :nail_care_nail_hardener_products,
      nail_glue_remover_products: :nail_and_cuticle_products,
      nail_glue_remover: :nail_glue_remover_products,
      other_nail_and_cuticle_products: :nail_and_cuticle_products,
      cuticle_remover_softener: :other_nail_and_cuticle_products,
      nail_sculpting_products: :other_nail_and_cuticle_products,
      other_nail_and_cuticle_products_child: :other_nail_and_cuticle_products,
      tooth_care_products: :oral_hygiene_products,
      toothpaste: :tooth_care_products,
      tooth_cleansing_powder_salt: :tooth_care_products,
      other_tooth_care_products: :tooth_care_products,
      mouth_wash_breath_spray: :oral_hygiene_products,
      mouth_wash: :mouth_wash_breath_spray,
      breath_spray: :mouth_wash_breath_spray,
      other_mouth_wash_breath_spray_products: :mouth_wash_breath_spray,
      tooth_whiteners: :oral_hygiene_products,
      tooth_whiteners_child: :tooth_whiteners,
      other_oral_hygiene_products: :oral_hygiene_products,
      other_oral_hygiene_products_child: :other_oral_hygiene_products,
    }.freeze
  end
end
