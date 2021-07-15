# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210624085951) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"
  enable_extension "pg_trgm"

  create_table "active_poll_translations", force: :cascade do |t|
    t.integer  "active_poll_id", null: false
    t.string   "locale",         null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "description"
    t.index ["active_poll_id"], name: "index_active_poll_translations_on_active_poll_id", using: :btree
    t.index ["locale"], name: "index_active_poll_translations_on_locale", using: :btree
  end

  create_table "active_polls", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "action"
    t.integer  "actionable_id"
    t.string   "actionable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["actionable_id", "actionable_type"], name: "index_activities_on_actionable_id_and_actionable_type", using: :btree
    t.index ["user_id"], name: "index_activities_on_user_id", using: :btree
  end

  create_table "actuations_multi_years", force: :cascade do |t|
    t.string  "annos"
    t.string  "values"
    t.integer "sures_actuations_id"
    t.index ["sures_actuations_id"], name: "index_actuations_multi_years_on_sures_actuations_id", using: :btree
  end

  create_table "admin_notification_translations", force: :cascade do |t|
    t.integer  "admin_notification_id", null: false
    t.string   "locale",                null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "title"
    t.text     "body"
    t.index ["admin_notification_id"], name: "index_admin_notification_translations_on_admin_notification_id", using: :btree
    t.index ["locale"], name: "index_admin_notification_translations_on_locale", using: :btree
  end

  create_table "admin_notifications", force: :cascade do |t|
    t.string   "link"
    t.string   "segment_recipient"
    t.integer  "recipients_count"
    t.date     "sent_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "administrators", force: :cascade do |t|
    t.integer "user_id"
    t.string  "description"
    t.index ["user_id"], name: "index_administrators_on_user_id", using: :btree
  end

  create_table "adresses", force: :cascade do |t|
    t.integer  "users_id"
    t.text     "road_type"
    t.text     "road_name"
    t.text     "road_number"
    t.text     "floor"
    t.text     "door"
    t.text     "gate"
    t.text     "district"
    t.text     "borought"
    t.text     "postal_code"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["users_id"], name: "index_adresses_on_users_id", using: :btree
  end

  create_table "ahoy_events", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid     "visit_id"
    t.integer  "user_id"
    t.string   "name"
    t.jsonb    "properties"
    t.datetime "time"
    t.string   "ip"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time", using: :btree
    t.index ["time"], name: "index_ahoy_events_on_time", using: :btree
    t.index ["user_id"], name: "index_ahoy_events_on_user_id", using: :btree
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id", using: :btree
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "author_id"
    t.text     "text"
    t.string   "context"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_answers_on_author_id", using: :btree
    t.index ["context"], name: "index_answers_on_context", using: :btree
  end

  create_table "banner_sections", force: :cascade do |t|
    t.integer  "banner_id"
    t.integer  "web_section_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "banner_translations", force: :cascade do |t|
    t.integer  "banner_id",   null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "title"
    t.text     "description"
    t.index ["banner_id"], name: "index_banner_translations_on_banner_id", using: :btree
    t.index ["locale"], name: "index_banner_translations_on_locale", using: :btree
  end

  create_table "banners", force: :cascade do |t|
    t.string   "target_url"
    t.date     "post_started_at"
    t.date     "post_ended_at"
    t.datetime "hidden_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.text     "background_color"
    t.text     "font_color"
    t.boolean  "subsection",       default: false
    t.index ["hidden_at"], name: "index_banners_on_hidden_at", using: :btree
  end

  create_table "budget_administrators", force: :cascade do |t|
    t.integer  "budget_id"
    t.integer  "administrator_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["administrator_id"], name: "index_budget_administrators_on_administrator_id", using: :btree
    t.index ["budget_id"], name: "index_budget_administrators_on_budget_id", using: :btree
  end

  create_table "budget_ballot_lines", force: :cascade do |t|
    t.integer  "ballot_id"
    t.integer  "investment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "budget_id"
    t.integer  "group_id"
    t.integer  "heading_id"
    t.index ["ballot_id", "investment_id"], name: "index_budget_ballot_lines_on_ballot_id_and_investment_id", unique: true, using: :btree
    t.index ["ballot_id"], name: "index_budget_ballot_lines_on_ballot_id", using: :btree
    t.index ["investment_id"], name: "index_budget_ballot_lines_on_investment_id", using: :btree
  end

  create_table "budget_ballots", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "budget_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "ballot_lines_count", default: 0
    t.boolean  "physical",           default: false
    t.integer  "poll_ballot_id"
  end

  create_table "budget_content_blocks", force: :cascade do |t|
    t.integer  "heading_id"
    t.text     "body"
    t.string   "locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["heading_id"], name: "index_budget_content_blocks_on_heading_id", using: :btree
  end

  create_table "budget_group_translations", force: :cascade do |t|
    t.integer  "budget_group_id", null: false
    t.string   "locale",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "name"
    t.index ["budget_group_id"], name: "index_budget_group_translations_on_budget_group_id", using: :btree
    t.index ["locale"], name: "index_budget_group_translations_on_locale", using: :btree
  end

  create_table "budget_groups", force: :cascade do |t|
    t.integer "budget_id"
    t.string  "slug"
    t.integer "max_votable_headings",     default: 1
    t.integer "max_supportable_headings", default: 1
    t.index ["budget_id"], name: "index_budget_groups_on_budget_id", using: :btree
  end

  create_table "budget_heading_translations", force: :cascade do |t|
    t.integer  "budget_heading_id", null: false
    t.string   "locale",            null: false
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "name"
    t.index ["budget_heading_id"], name: "index_budget_heading_translations_on_budget_heading_id", using: :btree
    t.index ["locale"], name: "index_budget_heading_translations_on_locale", using: :btree
  end

  create_table "budget_headings", force: :cascade do |t|
    t.integer "group_id"
    t.bigint  "price"
    t.string  "slug"
    t.integer "population"
    t.boolean "allow_custom_content", default: false
    t.text    "latitude"
    t.text    "longitude"
    t.index ["group_id"], name: "index_budget_headings_on_group_id", using: :btree
  end

  create_table "budget_investment_change_logs", force: :cascade do |t|
    t.integer  "investment_id"
    t.integer  "author_id"
    t.string   "field"
    t.string   "new_value"
    t.string   "old_value"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "budget_investment_milestone_translations", force: :cascade do |t|
    t.integer  "budget_investment_milestone_id", null: false
    t.string   "locale",                         null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "title"
    t.text     "description"
    t.index ["budget_investment_milestone_id"], name: "index_6770e7675fe296cf87aa0fd90492c141b5269e0b", using: :btree
    t.index ["locale"], name: "index_budget_investment_milestone_translations_on_locale", using: :btree
  end

  create_table "budget_investment_milestones", force: :cascade do |t|
    t.integer  "investment_id"
    t.string   "title",            limit: 80
    t.text     "description"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.datetime "publication_date"
    t.integer  "status_id"
    t.index ["status_id"], name: "index_budget_investment_milestones_on_status_id", using: :btree
  end

  create_table "budget_investment_statuses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "hidden_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["hidden_at"], name: "index_budget_investment_statuses_on_hidden_at", using: :btree
  end

  create_table "budget_investments", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "administrator_id"
    t.string   "title"
    t.text     "description"
    t.string   "external_url"
    t.bigint   "price"
    t.string   "feasibility",                      limit: 15, default: "undecided"
    t.text     "price_explanation"
    t.text     "unfeasibility_explanation"
    t.boolean  "valuation_finished",                          default: false
    t.integer  "valuator_assignments_count",                  default: 0
    t.bigint   "price_first_year"
    t.string   "duration"
    t.datetime "hidden_at"
    t.integer  "cached_votes_up",                             default: 0
    t.integer  "comments_count",                              default: 0
    t.integer  "confidence_score",                            default: 0,           null: false
    t.integer  "physical_votes",                              default: 0
    t.tsvector "tsv"
    t.datetime "created_at",                                                        null: false
    t.datetime "updated_at",                                                        null: false
    t.integer  "heading_id"
    t.string   "responsible_name"
    t.integer  "budget_id"
    t.integer  "group_id"
    t.boolean  "selected",                                    default: false
    t.string   "location"
    t.string   "organization_name"
    t.datetime "unfeasible_email_sent_at"
    t.string   "label"
    t.integer  "previous_heading_id"
    t.boolean  "visible_to_valuators",                        default: false
    t.integer  "ballot_lines_count",                          default: 0
    t.boolean  "winner",                                      default: false
    t.boolean  "incompatible",                                default: false
    t.integer  "community_id"
    t.integer  "valuator_group_assignments_count",            default: 0
    t.datetime "confirmed_hide_at"
    t.datetime "ignored_flag_at"
    t.integer  "flags_count",                                 default: 0
    t.integer  "tracker_assignments_count"
    t.integer  "original_heading_id"
    t.index ["administrator_id"], name: "index_budget_investments_on_administrator_id", using: :btree
    t.index ["author_id"], name: "index_budget_investments_on_author_id", using: :btree
    t.index ["community_id"], name: "index_budget_investments_on_community_id", using: :btree
    t.index ["heading_id"], name: "index_budget_investments_on_heading_id", using: :btree
    t.index ["tsv"], name: "index_budget_investments_on_tsv", using: :gin
  end

  create_table "budget_phase_translations", force: :cascade do |t|
    t.integer  "budget_phase_id", null: false
    t.string   "locale",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "description"
    t.text     "summary"
    t.index ["budget_phase_id"], name: "index_budget_phase_translations_on_budget_phase_id", using: :btree
    t.index ["locale"], name: "index_budget_phase_translations_on_locale", using: :btree
  end

  create_table "budget_phases", force: :cascade do |t|
    t.integer  "budget_id"
    t.integer  "next_phase_id"
    t.string   "kind",                         null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "enabled",       default: true
    t.index ["ends_at"], name: "index_budget_phases_on_ends_at", using: :btree
    t.index ["kind"], name: "index_budget_phases_on_kind", using: :btree
    t.index ["next_phase_id"], name: "index_budget_phases_on_next_phase_id", using: :btree
    t.index ["starts_at"], name: "index_budget_phases_on_starts_at", using: :btree
  end

  create_table "budget_polls", force: :cascade do |t|
    t.string  "name"
    t.string  "email"
    t.string  "preferred_subject"
    t.boolean "collective"
    t.boolean "public_worker"
    t.boolean "proposal_author"
    t.boolean "selected_proposal_author"
  end

  create_table "budget_reclassified_votes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "investment_id"
    t.string   "reason"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "budget_rol_assignments", force: :cascade do |t|
    t.integer  "budget_id"
    t.integer  "user_id"
    t.string   "rol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_budget_rol_assignments_on_budget_id", using: :btree
    t.index ["user_id"], name: "index_budget_rol_assignments_on_user_id", using: :btree
  end

  create_table "budget_tracker_assignments", force: :cascade do |t|
    t.integer  "tracker_id"
    t.integer  "investment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["investment_id"], name: "index_budget_tracker_assignments_on_investment_id", using: :btree
    t.index ["tracker_id"], name: "index_budget_tracker_assignments_on_tracker_id", using: :btree
  end

  create_table "budget_trackers", force: :cascade do |t|
    t.integer  "budget_id"
    t.integer  "tracker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_budget_trackers_on_budget_id", using: :btree
    t.index ["tracker_id"], name: "index_budget_trackers_on_tracker_id", using: :btree
  end

  create_table "budget_translations", force: :cascade do |t|
    t.integer  "budget_id",  null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.index ["budget_id"], name: "index_budget_translations_on_budget_id", using: :btree
    t.index ["locale"], name: "index_budget_translations_on_locale", using: :btree
  end

  create_table "budget_valuator_assignments", force: :cascade do |t|
    t.integer  "valuator_id"
    t.integer  "investment_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["investment_id"], name: "index_budget_valuator_assignments_on_investment_id", using: :btree
  end

  create_table "budget_valuator_group_assignments", force: :cascade do |t|
    t.integer "valuator_group_id"
    t.integer "investment_id"
  end

  create_table "budget_valuators", force: :cascade do |t|
    t.integer  "budget_id"
    t.integer  "valuator_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["budget_id"], name: "index_budget_valuators_on_budget_id", using: :btree
    t.index ["valuator_id"], name: "index_budget_valuators_on_valuator_id", using: :btree
  end

  create_table "budgets", force: :cascade do |t|
    t.string   "currency_symbol",               limit: 10
    t.string   "phase",                         limit: 40, default: "accepting"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.text     "description_accepting"
    t.text     "description_reviewing"
    t.text     "description_selecting"
    t.text     "description_valuating"
    t.text     "description_balloting"
    t.text     "description_reviewing_ballots"
    t.text     "description_finished"
    t.string   "slug"
    t.text     "description_drafting"
    t.text     "description_publishing_prices"
    t.text     "description_informing"
    t.string   "help_link"
    t.string   "budget_milestone_tags"
    t.string   "budget_valuation_tags"
    t.text     "budget_link"
    t.boolean  "budget_link_enabled",                      default: false
  end

  create_table "campaigns", force: :cascade do |t|
    t.string   "name"
    t.string   "track_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "data_fingerprint"
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "hidden_at"
    t.integer  "flags_count",        default: 0
    t.datetime "ignored_flag_at"
    t.integer  "moderator_id"
    t.integer  "administrator_id"
    t.integer  "cached_votes_total", default: 0
    t.integer  "cached_votes_up",    default: 0
    t.integer  "cached_votes_down",  default: 0
    t.datetime "confirmed_hide_at"
    t.string   "ancestry"
    t.integer  "confidence_score",   default: 0,     null: false
    t.boolean  "valuation",          default: false
    t.index ["ancestry"], name: "index_comments_on_ancestry", using: :btree
    t.index ["cached_votes_down"], name: "index_comments_on_cached_votes_down", using: :btree
    t.index ["cached_votes_total"], name: "index_comments_on_cached_votes_total", using: :btree
    t.index ["cached_votes_up"], name: "index_comments_on_cached_votes_up", using: :btree
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
    t.index ["hidden_at"], name: "index_comments_on_hidden_at", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
    t.index ["valuation"], name: "index_comments_on_valuation", using: :btree
  end

  create_table "communities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "complan_activities", force: :cascade do |t|
    t.text     "description"
    t.string   "activity"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "complan_performance_id"
    t.index ["complan_performance_id"], name: "index_complan_activities_on_complan_performance_id", using: :btree
  end

  create_table "complan_ambits", force: :cascade do |t|
    t.text     "description"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "complan_performance_id"
    t.index ["complan_performance_id"], name: "index_complan_ambits_on_complan_performance_id", using: :btree
  end

  create_table "complan_assistants", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "complan_person_id"
    t.integer  "complan_thecnical_table_id"
    t.index ["complan_person_id"], name: "index_complan_assistants_on_complan_person_id", using: :btree
    t.index ["complan_thecnical_table_id"], name: "index_complan_assistants_on_complan_thecnical_table_id", using: :btree
  end

  create_table "complan_beneficiaries", force: :cascade do |t|
    t.text     "description"
    t.integer  "count_participants"
    t.integer  "count_men"
    t.integer  "count_women"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "complan_performance_id"
    t.index ["complan_performance_id"], name: "index_complan_beneficiaries_on_complan_performance_id", using: :btree
  end

  create_table "complan_beneficiaries_typologies", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "complan_beneficiary_id"
    t.integer  "complan_typology_id"
    t.index ["complan_beneficiary_id"], name: "index_complan_bt_beneficiary", using: :btree
    t.index ["complan_typology_id"], name: "index_complan_bt_typology", using: :btree
  end

  create_table "complan_centers", force: :cascade do |t|
    t.string   "organism"
    t.string   "dg"
    t.string   "sg"
    t.string   "denomination"
    t.string   "address"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "complan_credit_modifications", force: :cascade do |t|
    t.string   "departure_destination"
    t.string   "number_file"
    t.date     "mc_accept"
    t.date     "of_remission"
    t.date     "posted"
    t.string   "count_credit"
    t.string   "ad_aprobed"
    t.string   "o_aprobed"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "complan_import_id"
    t.index ["complan_import_id"], name: "index_complan_credit_modifications_on_complan_import_id", using: :btree
  end

  create_table "complan_editors", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_complan_editors_on_user_id", using: :btree
  end

  create_table "complan_files", force: :cascade do |t|
    t.string   "number_file"
    t.string   "type_file"
    t.date     "proposal_date"
    t.date     "start_date"
    t.date     "approval_date"
    t.date     "accounting_date"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "complan_financing_id"
    t.index ["complan_financing_id"], name: "index_complan_files_on_complan_financing_id", using: :btree
  end

  create_table "complan_financings", force: :cascade do |t|
    t.integer  "start_year"
    t.string   "type_financing"
    t.string   "type_subfinancing"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "complan_imports", force: :cascade do |t|
    t.float    "import"
    t.string   "type_import"
    t.string   "annuity"
    t.float    "import_start_assing"
    t.float    "import_requested"
    t.float    "import_remaining"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "complan_financing_id"
    t.integer  "complan_center_id"
    t.index ["complan_center_id"], name: "index_complan_imports_on_complan_center_id", using: :btree
    t.index ["complan_financing_id"], name: "index_complan_imports_on_complan_financing_id", using: :btree
  end

  create_table "complan_indicators", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "numeric_value"
    t.integer  "provided"
    t.integer  "done"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "complan_performance_id"
    t.index ["complan_performance_id"], name: "index_complan_indicators_on_complan_performance_id", using: :btree
  end

  create_table "complan_locations", force: :cascade do |t|
    t.string   "district"
    t.string   "borought"
    t.string   "address"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "complan_financing_id"
    t.index ["complan_financing_id"], name: "index_complan_locations_on_complan_financing_id", using: :btree
  end

  create_table "complan_medias", force: :cascade do |t|
    t.text     "text_document"
    t.string   "title"
    t.string   "origin"
    t.date     "date_document"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "complan_performance_id"
    t.index ["complan_performance_id"], name: "index_complan_medias_on_complan_performance_id", using: :btree
  end

  create_table "complan_people", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "email"
    t.string   "position"
    t.string   "address"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "complan_center_id"
    t.index ["complan_center_id"], name: "index_complan_people_on_complan_center_id", using: :btree
  end

  create_table "complan_performances", force: :cascade do |t|
    t.string   "type_performance"
    t.text     "description"
    t.text     "comments"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "status"
    t.integer  "annuity"
    t.integer  "valued"
    t.integer  "vulnerability_index"
    t.integer  "edition"
    t.integer  "multi_year"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "complan_project_id"
    t.integer  "complan_financing_id"
    t.index ["complan_financing_id"], name: "index_complan_performances_on_complan_financing_id", using: :btree
    t.index ["complan_project_id"], name: "index_complan_performances_on_complan_project_id", using: :btree
  end

  create_table "complan_projects", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "complan_strategy_id"
    t.index ["complan_strategy_id"], name: "index_complan_projects_on_complan_strategy_id", using: :btree
  end

  create_table "complan_readers", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_complan_readers_on_user_id", using: :btree
  end

  create_table "complan_strategies", force: :cascade do |t|
    t.string   "name"
    t.string   "departure"
    t.text     "description"
    t.date     "approbal_date"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "complan_thecnical_tables", force: :cascade do |t|
    t.date     "date_at"
    t.text     "description"
    t.string   "name"
    t.string   "year"
    t.string   "type"
    t.date     "date_agreement"
    t.string   "sesion"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "complan_performance_id"
    t.index ["complan_performance_id"], name: "index_complan_thecnical_tables_on_complan_performance_id", using: :btree
  end

  create_table "complan_trackings", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "complan_performance_id"
    t.index ["complan_performance_id"], name: "index_complan_trackings_on_complan_performance_id", using: :btree
  end

  create_table "complan_typologies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "consultants", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_consultants_on_user_id", using: :btree
  end

  create_table "custom_page_modules", force: :cascade do |t|
    t.integer  "custom_page_id"
    t.string   "type"
    t.integer  "position",                       default: 0
    t.boolean  "disabled",                       default: false
    t.string   "subtitle"
    t.text     "claim"
    t.text     "rich_text"
    t.string   "youtube_url"
    t.string   "cta_text"
    t.string   "cta_button"
    t.string   "cta_link"
    t.text     "js_snippet"
    t.string   "custom_image_file_name"
    t.string   "custom_image_content_type"
    t.integer  "custom_image_file_size"
    t.datetime "custom_image_updated_at"
    t.text     "custom_image_alt"
    t.string   "promo_location_one"
    t.string   "promo_title_one"
    t.text     "promo_description_one"
    t.string   "promo_image_one_file_name"
    t.string   "promo_image_one_content_type"
    t.integer  "promo_image_one_file_size"
    t.datetime "promo_image_one_updated_at"
    t.string   "promo_alt_image_one"
    t.string   "promo_link_one"
    t.string   "promo_location_two"
    t.string   "promo_title_two"
    t.text     "promo_description_two"
    t.string   "promo_image_two_file_name"
    t.string   "promo_image_two_content_type"
    t.integer  "promo_image_two_file_size"
    t.datetime "promo_image_two_updated_at"
    t.string   "promo_alt_image_two"
    t.string   "promo_link_two"
    t.string   "promo_location_three"
    t.string   "promo_title_three"
    t.text     "promo_description_three"
    t.string   "promo_image_three_file_name"
    t.string   "promo_image_three_content_type"
    t.integer  "promo_image_three_file_size"
    t.datetime "promo_image_three_updated_at"
    t.string   "promo_alt_image_three"
    t.string   "promo_link_three"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.index ["type", "custom_page_id"], name: "index_custom_page_modules_on_type_and_custom_page_id", using: :btree
  end

  create_table "custom_pages", force: :cascade do |t|
    t.string   "title"
    t.string   "parent_slug"
    t.string   "slug"
    t.string   "meta_title"
    t.string   "meta_description"
    t.string   "meta_keywords"
    t.boolean  "canonical"
    t.boolean  "published"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["user_id"], name: "index_custom_pages_on_user_id", using: :btree
  end

  create_table "dashboard_actions", force: :cascade do |t|
    t.string   "title",                     limit: 80
    t.text     "description"
    t.string   "link"
    t.boolean  "request_to_administrators",            default: false
    t.integer  "day_offset",                           default: 0
    t.integer  "required_supports",                    default: 0
    t.integer  "order",                                default: 0
    t.boolean  "active",                               default: true
    t.datetime "hidden_at"
    t.integer  "action_type",                          default: 0,     null: false
    t.string   "short_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published_proposal",                   default: false
  end

  create_table "dashboard_administrator_tasks", force: :cascade do |t|
    t.string   "source_type"
    t.integer  "source_id"
    t.integer  "user_id"
    t.datetime "executed_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["source_type", "source_id"], name: "index_dashboard_administrator_tasks_on_source", using: :btree
    t.index ["user_id"], name: "index_dashboard_administrator_tasks_on_user_id", using: :btree
  end

  create_table "dashboard_executed_actions", force: :cascade do |t|
    t.integer  "proposal_id"
    t.integer  "action_id"
    t.datetime "executed_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["action_id"], name: "index_proposal_action", using: :btree
    t.index ["proposal_id"], name: "index_dashboard_executed_actions_on_proposal_id", using: :btree
  end

  create_table "debates", force: :cascade do |t|
    t.string   "title",                        limit: 80
    t.text     "description"
    t.integer  "author_id"
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.string   "visit_id"
    t.datetime "hidden_at"
    t.integer  "flags_count",                             default: 0
    t.datetime "ignored_flag_at"
    t.integer  "cached_votes_total",                      default: 0
    t.integer  "cached_votes_up",                         default: 0
    t.integer  "cached_votes_down",                       default: 0
    t.integer  "comments_count",                          default: 0
    t.datetime "confirmed_hide_at"
    t.integer  "cached_anonymous_votes_total",            default: 0
    t.integer  "cached_votes_score",                      default: 0
    t.bigint   "hot_score",                               default: 0
    t.integer  "confidence_score",                        default: 0
    t.integer  "geozone_id"
    t.tsvector "tsv"
    t.datetime "featured_at"
    t.string   "comment_kind",                            default: "comment"
    t.index ["author_id", "hidden_at"], name: "index_debates_on_author_id_and_hidden_at", using: :btree
    t.index ["author_id"], name: "index_debates_on_author_id", using: :btree
    t.index ["cached_votes_down"], name: "index_debates_on_cached_votes_down", using: :btree
    t.index ["cached_votes_score"], name: "index_debates_on_cached_votes_score", using: :btree
    t.index ["cached_votes_total"], name: "index_debates_on_cached_votes_total", using: :btree
    t.index ["cached_votes_up"], name: "index_debates_on_cached_votes_up", using: :btree
    t.index ["confidence_score"], name: "index_debates_on_confidence_score", using: :btree
    t.index ["geozone_id"], name: "index_debates_on_geozone_id", using: :btree
    t.index ["hidden_at"], name: "index_debates_on_hidden_at", using: :btree
    t.index ["hot_score"], name: "index_debates_on_hot_score", using: :btree
    t.index ["title"], name: "index_debates_on_title", using: :btree
    t.index ["tsv"], name: "index_debates_on_tsv", using: :gin
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "direct_messages", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "documents", force: :cascade do |t|
    t.string   "title"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "user_id"
    t.integer  "documentable_id"
    t.string   "documentable_type"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "admin",                   default: false
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable_type_and_documentable_id", using: :btree
    t.index ["user_id", "documentable_type", "documentable_id"], name: "access_documents", using: :btree
    t.index ["user_id"], name: "index_documents_on_user_id", using: :btree
  end

  create_table "download_settings", force: :cascade do |t|
    t.string   "name_model",                   null: false
    t.string   "name_field",                   null: false
    t.boolean  "downloadable", default: false, null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "config",       default: 0,     null: false
    t.index ["name_model", "name_field", "config"], name: "index_download_settings_on_name_model_and_name_field_and_config", unique: true, using: :btree
  end

  create_table "editors", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_editors_on_user_id", using: :btree
  end

  create_table "event_agends", force: :cascade do |t|
    t.date     "date_at"
    t.string   "hour_at"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "hour_to"
  end

  create_table "failed_census_calls", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "document_number"
    t.string   "document_type"
    t.date     "date_of_birth"
    t.string   "postal_code"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "district_code"
    t.integer  "poll_officer_id"
    t.integer  "year_of_birth"
    t.index ["user_id"], name: "index_failed_census_calls_on_user_id", using: :btree
  end

  create_table "flags", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "flaggable_type"
    t.integer  "flaggable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["flaggable_type", "flaggable_id"], name: "index_flags_on_flaggable_type_and_flaggable_id", using: :btree
    t.index ["user_id", "flaggable_type", "flaggable_id"], name: "access_inappropiate_flags", using: :btree
    t.index ["user_id"], name: "index_flags_on_user_id", using: :btree
  end

  create_table "follows", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "followable_id"
    t.string   "followable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["followable_type", "followable_id"], name: "index_follows_on_followable_type_and_followable_id", using: :btree
    t.index ["user_id", "followable_type", "followable_id"], name: "access_follows", using: :btree
    t.index ["user_id"], name: "index_follows_on_user_id", using: :btree
  end

  create_table "geozones", force: :cascade do |t|
    t.string   "name"
    t.string   "html_map_coordinates"
    t.string   "external_code"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "census_code"
    t.string   "code_district"
  end

  create_table "geozones_legislation_processes", force: :cascade do |t|
    t.integer "geozone_id"
    t.integer "legislation_process_id"
    t.index ["geozone_id"], name: "index_geozones_legislation_processes_on_geozone_id", using: :btree
    t.index ["legislation_process_id"], name: "index_geozones_legislation_processes_on_legislation_process_id", using: :btree
  end

  create_table "geozones_polls", force: :cascade do |t|
    t.integer "geozone_id"
    t.integer "poll_id"
    t.index ["geozone_id"], name: "index_geozones_polls_on_geozone_id", using: :btree
    t.index ["poll_id"], name: "index_geozones_polls_on_poll_id", using: :btree
  end

  create_table "i18n_content_translations", force: :cascade do |t|
    t.integer  "i18n_content_id", null: false
    t.string   "locale",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "value"
    t.index ["i18n_content_id"], name: "index_i18n_content_translations_on_i18n_content_id", using: :btree
    t.index ["locale"], name: "index_i18n_content_translations_on_locale", using: :btree
  end

  create_table "i18n_contents", force: :cascade do |t|
    t.string "key"
  end

  create_table "identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "images", force: :cascade do |t|
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.string   "title",                   limit: 80
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "user_id"
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id", using: :btree
    t.index ["user_id"], name: "index_images_on_user_id", using: :btree
  end

  create_table "legislation_annotations", force: :cascade do |t|
    t.string   "quote"
    t.text     "ranges"
    t.text     "text"
    t.integer  "legislation_draft_version_id"
    t.integer  "author_id"
    t.datetime "hidden_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "comments_count",               default: 0
    t.string   "range_start"
    t.integer  "range_start_offset"
    t.string   "range_end"
    t.integer  "range_end_offset"
    t.text     "context"
    t.index ["author_id"], name: "index_legislation_annotations_on_author_id", using: :btree
    t.index ["hidden_at"], name: "index_legislation_annotations_on_hidden_at", using: :btree
    t.index ["legislation_draft_version_id"], name: "index_legislation_annotations_on_legislation_draft_version_id", using: :btree
    t.index ["range_start", "range_end"], name: "index_legislation_annotations_on_range_start_and_range_end", using: :btree
  end

  create_table "legislation_answers", force: :cascade do |t|
    t.integer  "legislation_question_id"
    t.integer  "legislation_question_option_id"
    t.integer  "user_id"
    t.datetime "hidden_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "value_other"
    t.integer  "value_range"
    t.integer  "value_number"
    t.index ["hidden_at"], name: "index_legislation_answers_on_hidden_at", using: :btree
    t.index ["legislation_question_id"], name: "index_legislation_answers_on_legislation_question_id", using: :btree
    t.index ["legislation_question_option_id"], name: "index_legislation_answers_on_legislation_question_option_id", using: :btree
    t.index ["user_id"], name: "index_legislation_answers_on_user_id", using: :btree
  end

  create_table "legislation_cat_prop", force: :cascade do |t|
    t.integer "category_id"
    t.integer "proposal_id"
    t.index ["category_id"], name: "index_legislation_cat_prop_on_category_id", using: :btree
    t.index ["proposal_id"], name: "index_legislation_cat_prop_on_proposal_id", using: :btree
  end

  create_table "legislation_categories", force: :cascade do |t|
    t.text     "name"
    t.text     "tag"
    t.integer  "legislation_process_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["legislation_process_id"], name: "index_legislation_categories_on_legislation_process_id", using: :btree
  end

  create_table "legislation_draft_version_translations", force: :cascade do |t|
    t.integer  "legislation_draft_version_id", null: false
    t.string   "locale",                       null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "title"
    t.text     "changelog"
    t.text     "body"
    t.text     "body_html"
    t.text     "toc_html"
    t.index ["legislation_draft_version_id"], name: "index_900e5ba94457606e69e89193db426e8ddff809bc", using: :btree
    t.index ["locale"], name: "index_legislation_draft_version_translations_on_locale", using: :btree
  end

  create_table "legislation_draft_versions", force: :cascade do |t|
    t.integer  "legislation_process_id"
    t.string   "status",                 default: "draft"
    t.boolean  "final_version",          default: false
    t.datetime "hidden_at"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["hidden_at"], name: "index_legislation_draft_versions_on_hidden_at", using: :btree
    t.index ["legislation_process_id"], name: "index_legislation_draft_versions_on_legislation_process_id", using: :btree
    t.index ["status"], name: "index_legislation_draft_versions_on_status", using: :btree
  end

  create_table "legislation_other_proposals", force: :cascade do |t|
    t.text     "type_other_proposal"
    t.text     "name"
    t.text     "address"
    t.text     "phone"
    t.text     "agent"
    t.text     "agent_title"
    t.boolean  "citizen_entities"
    t.text     "cif"
    t.text     "entity_type"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "justify_text_declaration_1"
    t.boolean  "justify_text_declaration_2"
  end

  create_table "legislation_people_proposals", force: :cascade do |t|
    t.integer  "legislation_process_id"
    t.string   "title",                  limit: 80
    t.text     "description"
    t.string   "question"
    t.integer  "author_id"
    t.datetime "hidden_at"
    t.integer  "flags_count",                       default: 0
    t.datetime "ignored_flag_at"
    t.integer  "cached_votes_up",                   default: 0
    t.integer  "comments_count",                    default: 0
    t.datetime "confirmed_hide_at"
    t.bigint   "hot_score",                         default: 0
    t.integer  "confidence_score",                  default: 0
    t.string   "responsible_name",       limit: 60
    t.text     "summary"
    t.string   "video_url"
    t.tsvector "tsv"
    t.datetime "retired_at"
    t.string   "retired_reason"
    t.text     "retired_explanation"
    t.integer  "community_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "cached_votes_total",                default: 0
    t.integer  "cached_votes_down",                 default: 0
    t.boolean  "selected"
    t.boolean  "validated"
    t.integer  "cached_votes_score",                default: 0
    t.string   "email"
    t.string   "phone"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "instagram"
    t.string   "youtube"
    t.string   "website"
    t.index ["cached_votes_score"], name: "index_legislation_people_proposals_on_cached_votes_score", using: :btree
  end

  create_table "legislation_process_translations", force: :cascade do |t|
    t.integer  "legislation_process_id", null: false
    t.string   "locale",                 null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "title"
    t.text     "summary"
    t.text     "description"
    t.text     "additional_info"
    t.text     "milestones_summary"
    t.text     "homepage"
    t.index ["legislation_process_id"], name: "index_199e5fed0aca73302243f6a1fca885ce10cdbb55", using: :btree
    t.index ["locale"], name: "index_legislation_process_translations_on_locale", using: :btree
  end

  create_table "legislation_processes", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.date     "debate_start_date"
    t.date     "debate_end_date"
    t.date     "draft_publication_date"
    t.date     "allegations_start_date"
    t.date     "allegations_end_date"
    t.date     "result_publication_date"
    t.datetime "hidden_at"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.boolean  "debate_phase_enabled",              default: false
    t.boolean  "allegations_phase_enabled",         default: false
    t.boolean  "draft_publication_enabled",         default: false
    t.boolean  "result_publication_enabled",        default: false
    t.boolean  "published",                         default: true
    t.date     "proposals_phase_start_date"
    t.date     "proposals_phase_end_date"
    t.boolean  "proposals_phase_enabled"
    t.text     "proposals_description"
    t.boolean  "film_library",                      default: false
    t.date     "draft_start_date"
    t.date     "draft_end_date"
    t.boolean  "draft_phase_enabled",               default: false
    t.boolean  "homepage_enabled",                  default: false
    t.text     "background_color"
    t.text     "font_color"
    t.date     "people_proposals_phase_start_date"
    t.date     "people_proposals_phase_end_date"
    t.boolean  "people_proposals_phase_enabled"
    t.boolean  "geozone_restricted",                default: false
    t.boolean  "other_proposals_enabled"
    t.boolean  "permit_text_proposals"
    t.boolean  "permit_proposals_top_relevance"
    t.boolean  "permit_hiden_proposals"
    t.boolean  "permit_like_proposals",             default: false
    t.string   "proposals_title"
    t.integer  "film_library_limit"
    t.boolean  "film_library_admin",                default: false
    t.index ["allegations_end_date"], name: "index_legislation_processes_on_allegations_end_date", using: :btree
    t.index ["allegations_start_date"], name: "index_legislation_processes_on_allegations_start_date", using: :btree
    t.index ["debate_end_date"], name: "index_legislation_processes_on_debate_end_date", using: :btree
    t.index ["debate_start_date"], name: "index_legislation_processes_on_debate_start_date", using: :btree
    t.index ["draft_end_date"], name: "index_legislation_processes_on_draft_end_date", using: :btree
    t.index ["draft_publication_date"], name: "index_legislation_processes_on_draft_publication_date", using: :btree
    t.index ["draft_start_date"], name: "index_legislation_processes_on_draft_start_date", using: :btree
    t.index ["end_date"], name: "index_legislation_processes_on_end_date", using: :btree
    t.index ["hidden_at"], name: "index_legislation_processes_on_hidden_at", using: :btree
    t.index ["result_publication_date"], name: "index_legislation_processes_on_result_publication_date", using: :btree
    t.index ["start_date"], name: "index_legislation_processes_on_start_date", using: :btree
  end

  create_table "legislation_proposals", force: :cascade do |t|
    t.integer  "legislation_process_id"
    t.text     "title"
    t.text     "description"
    t.integer  "author_id"
    t.datetime "hidden_at"
    t.integer  "flags_count",                              default: 0
    t.datetime "ignored_flag_at"
    t.integer  "cached_votes_up",                          default: 0
    t.integer  "comments_count",                           default: 0
    t.datetime "confirmed_hide_at"
    t.bigint   "hot_score",                                default: 0
    t.integer  "confidence_score",                         default: 0
    t.string   "responsible_name",              limit: 60
    t.text     "summary"
    t.string   "video_url"
    t.tsvector "tsv"
    t.integer  "geozone_id"
    t.datetime "retired_at"
    t.string   "retired_reason"
    t.text     "retired_explanation"
    t.integer  "community_id"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.integer  "cached_votes_total",                       default: 0
    t.integer  "cached_votes_down",                        default: 0
    t.string   "proposal_type"
    t.boolean  "selected"
    t.integer  "cached_votes_score",                       default: 0
    t.text     "type_other_proposal"
    t.integer  "legislation_other_proposal_id"
    t.index ["cached_votes_score"], name: "index_legislation_proposals_on_cached_votes_score", using: :btree
    t.index ["legislation_other_proposal_id"], name: "index_legislation_proposals_on_legislation_other_proposal_id", using: :btree
    t.index ["legislation_process_id"], name: "index_legislation_proposals_on_legislation_process_id", using: :btree
  end

  create_table "legislation_question_option_translations", force: :cascade do |t|
    t.integer  "legislation_question_option_id",                 null: false
    t.string   "locale",                                         null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "value"
    t.boolean  "other",                          default: false
    t.boolean  "is_range"
    t.integer  "range_first",                    default: 1
    t.integer  "range_last",                     default: 2
    t.boolean  "is_number"
    t.index ["legislation_question_option_id"], name: "index_61bcec8729110b7f8e1e9e5ce08780878597a209", using: :btree
    t.index ["locale"], name: "index_legislation_question_option_translations_on_locale", using: :btree
  end

  create_table "legislation_question_options", force: :cascade do |t|
    t.integer  "legislation_question_id"
    t.integer  "answers_count",           default: 0
    t.datetime "hidden_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.boolean  "is_range"
    t.integer  "range_first",             default: 1
    t.integer  "range_last",              default: 2
    t.boolean  "is_number"
    t.index ["hidden_at"], name: "index_legislation_question_options_on_hidden_at", using: :btree
    t.index ["legislation_question_id"], name: "index_legislation_question_options_on_legislation_question_id", using: :btree
  end

  create_table "legislation_question_translations", force: :cascade do |t|
    t.integer  "legislation_question_id", null: false
    t.string   "locale",                  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.text     "title"
    t.index ["legislation_question_id"], name: "index_d34cc1e1fe6d5162210c41ce56533c5afabcdbd3", using: :btree
    t.index ["locale"], name: "index_legislation_question_translations_on_locale", using: :btree
  end

  create_table "legislation_questions", force: :cascade do |t|
    t.integer  "legislation_process_id"
    t.integer  "answers_count",          default: 0
    t.datetime "hidden_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "comments_count",         default: 0
    t.integer  "author_id"
    t.integer  "multiple_answers",       default: 1
    t.index ["hidden_at"], name: "index_legislation_questions_on_hidden_at", using: :btree
    t.index ["legislation_process_id"], name: "index_legislation_questions_on_legislation_process_id", using: :btree
  end

  create_table "links", force: :cascade do |t|
    t.string   "label"
    t.string   "url"
    t.string   "linkable_type"
    t.integer  "linkable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["linkable_type", "linkable_id"], name: "index_links_on_linkable_type_and_linkable_id", using: :btree
  end

  create_table "local_census_records", force: :cascade do |t|
    t.string   "document_number", null: false
    t.string   "document_type",   null: false
    t.date     "date_of_birth",   null: false
    t.string   "postal_code",     null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "locks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "tries",        default: 0
    t.datetime "locked_until", default: '2000-01-01 01:01:01', null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index ["user_id"], name: "index_locks_on_user_id", using: :btree
  end

  create_table "managers", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_managers_on_user_id", using: :btree
  end

  create_table "map_locations", force: :cascade do |t|
    t.float   "latitude"
    t.float   "longitude"
    t.integer "zoom"
    t.integer "proposal_id"
    t.integer "investment_id"
    t.index ["investment_id"], name: "index_map_locations_on_investment_id", using: :btree
    t.index ["proposal_id"], name: "index_map_locations_on_proposal_id", using: :btree
  end

  create_table "menu_items", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.string   "page_link"
    t.string   "item_type"
    t.integer  "position",       default: 0
    t.integer  "parent_item_id", default: 0
    t.boolean  "target_blank",   default: false
    t.boolean  "editable",       default: true
    t.boolean  "disabled",       default: false
    t.integer  "menu_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["menu_id"], name: "index_menu_items_on_menu_id", using: :btree
  end

  create_table "menus", force: :cascade do |t|
    t.string   "title"
    t.string   "section"
    t.boolean  "published",  default: false
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["user_id"], name: "index_menus_on_user_id", using: :btree
  end

  create_table "milestone_statuses", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "hidden_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["hidden_at"], name: "index_milestone_statuses_on_hidden_at", using: :btree
  end

  create_table "milestone_translations", force: :cascade do |t|
    t.integer  "milestone_id", null: false
    t.string   "locale",       null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "title"
    t.text     "description"
    t.index ["locale"], name: "index_milestone_translations_on_locale", using: :btree
    t.index ["milestone_id"], name: "index_milestone_translations_on_milestone_id", using: :btree
  end

  create_table "milestones", force: :cascade do |t|
    t.integer  "milestoneable_id"
    t.string   "milestoneable_type"
    t.datetime "publication_date"
    t.integer  "status_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["status_id"], name: "index_milestones_on_status_id", using: :btree
  end

  create_table "moderated_contents", force: :cascade do |t|
    t.string   "moderable_type"
    t.integer  "moderated_text_id"
    t.integer  "moderable_id"
    t.datetime "confirmed_at"
    t.datetime "declined_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["moderable_type", "moderable_id"], name: "index_moderated_contents_on_moderable_type_and_moderable_id", using: :btree
    t.index ["moderated_text_id"], name: "index_moderated_contents_on_moderated_text_id", using: :btree
  end

  create_table "moderated_texts", force: :cascade do |t|
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["text"], name: "index_moderated_texts_on_text", unique: true, using: :btree
  end

  create_table "moderators", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_moderators_on_user_id", using: :btree
  end

  create_table "newsletters", force: :cascade do |t|
    t.string   "subject"
    t.string   "segment_recipient", null: false
    t.string   "from"
    t.text     "body"
    t.date     "sent_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.datetime "hidden_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.integer  "counter",         default: 1
    t.datetime "emailed_at"
    t.datetime "read_at"
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "organizations", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",             limit: 60
    t.datetime "verified_at"
    t.datetime "rejected_at"
    t.string   "responsible_name", limit: 60
    t.index ["user_id"], name: "index_organizations_on_user_id", using: :btree
  end

  create_table "parbudget_ambits", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parbudget_assistants", force: :cascade do |t|
    t.string   "full_name",            null: false
    t.integer  "parbudget_meeting_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["parbudget_meeting_id"], name: "index_parbudget_assistants_on_parbudget_meeting_id", using: :btree
  end

  create_table "parbudget_centers", force: :cascade do |t|
    t.string   "denomination"
    t.string   "code"
    t.string   "code_section"
    t.string   "code_program"
    t.string   "responsible"
    t.string   "government_area"
    t.string   "general_direction"
    t.integer  "parbudget_project_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["parbudget_project_id"], name: "index_parbudget_centers_on_parbudget_project_id", using: :btree
  end

  create_table "parbudget_economic_budgets", force: :cascade do |t|
    t.integer  "year"
    t.decimal  "import"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "count_managing_body"
    t.string   "count_functional"
    t.string   "economic"
    t.string   "element_pep"
    t.string   "financing"
    t.string   "type_contract"
    t.integer  "parbudget_project_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["parbudget_project_id"], name: "index_parbudget_economic_budgets_on_parbudget_project_id", using: :btree
  end

  create_table "parbudget_editors", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_parbudget_editors_on_user_id", using: :btree
  end

  create_table "parbudget_links", force: :cascade do |t|
    t.string   "url",                  null: false
    t.integer  "parbudget_project_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["parbudget_project_id"], name: "index_parbudget_links_on_parbudget_project_id", using: :btree
  end

  create_table "parbudget_medias", force: :cascade do |t|
    t.text     "text_document"
    t.string   "title"
    t.integer  "parbudget_project_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.index ["parbudget_project_id"], name: "index_parbudget_medias_on_parbudget_project_id", using: :btree
  end

  create_table "parbudget_meetings", force: :cascade do |t|
    t.text     "reason"
    t.string   "who_requests"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.datetime "date_at"
  end

  create_table "parbudget_projects", force: :cascade do |t|
    t.string   "denomination"
    t.integer  "code"
    t.integer  "year"
    t.integer  "votes"
    t.integer  "cost"
    t.string   "author"
    t.string   "email"
    t.string   "phone"
    t.string   "url"
    t.text     "descriptive_memory"
    t.string   "entity"
    t.boolean  "plate_proceeds"
    t.boolean  "license_plate"
    t.integer  "code_old"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "parbudget_ambit_id"
    t.integer  "parbudget_topic_id"
    t.integer  "parbudget_responsible_id"
    t.string   "status"
    t.string   "web_title"
    t.boolean  "plate_installed"
    t.index ["parbudget_ambit_id"], name: "index_parbudget_projects_on_parbudget_ambit_id", using: :btree
    t.index ["parbudget_responsible_id"], name: "index_parbudget_projects_on_parbudget_responsible_id", using: :btree
    t.index ["parbudget_topic_id"], name: "index_parbudget_projects_on_parbudget_topic_id", using: :btree
  end

  create_table "parbudget_readers", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_parbudget_readers_on_user_id", using: :btree
  end

  create_table "parbudget_responsibles", force: :cascade do |t|
    t.string   "full_name"
    t.string   "phone"
    t.string   "email"
    t.string   "position"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "parbudget_center_id"
    t.index ["parbudget_center_id"], name: "index_parbudget_responsibles_on_parbudget_center_id", using: :btree
  end

  create_table "parbudget_topics", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parbudget_track_exts", force: :cascade do |t|
    t.integer  "parbudget_tracking_external_id"
    t.integer  "parbudget_tracking_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["parbudget_tracking_external_id"], name: "index_parbudget_track_exts_on_parbudget_tracking_external_id", using: :btree
    t.index ["parbudget_tracking_id"], name: "index_parbudget_track_exts_on_parbudget_tracking_id", using: :btree
  end

  create_table "parbudget_track_ints", force: :cascade do |t|
    t.integer  "parbudget_tracking_internal_id"
    t.integer  "parbudget_tracking_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["parbudget_tracking_id"], name: "index_parbudget_track_ints_on_parbudget_tracking_id", using: :btree
    t.index ["parbudget_tracking_internal_id"], name: "index_parbudget_track_ints_on_parbudget_tracking_internal_id", using: :btree
  end

  create_table "parbudget_tracking_externals", force: :cascade do |t|
    t.string   "code"
    t.string   "status"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "status_description"
  end

  create_table "parbudget_tracking_internals", force: :cascade do |t|
    t.text     "observations"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "file_send",    default: false
    t.boolean  "file_recived", default: false
    t.boolean  "file_edited",  default: false
  end

  create_table "parbudget_trackings", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "parbudget_project_id"
    t.index ["parbudget_project_id"], name: "index_parbudget_trackings_on_parbudget_project_id", using: :btree
  end

  create_table "parbudget_trackings_meetings", force: :cascade do |t|
    t.integer  "parbudget_meeting_id"
    t.integer  "parbudget_tracking_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["parbudget_meeting_id"], name: "index_parbudget_trackings_meetings_on_parbudget_meeting_id", using: :btree
    t.index ["parbudget_tracking_id"], name: "index_parbudget_trackings_meetings_on_parbudget_tracking_id", using: :btree
  end

  create_table "poll_answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "author_id"
    t.string   "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "positive"
    t.integer  "order"
    t.integer  "value"
    t.index ["author_id"], name: "index_poll_answers_on_author_id", using: :btree
    t.index ["question_id", "answer"], name: "index_poll_answers_on_question_id_and_answer", using: :btree
    t.index ["question_id"], name: "index_poll_answers_on_question_id", using: :btree
  end

  create_table "poll_ballot_sheets", force: :cascade do |t|
    t.text     "data"
    t.integer  "poll_id"
    t.integer  "officer_assignment_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["officer_assignment_id"], name: "index_poll_ballot_sheets_on_officer_assignment_id", using: :btree
    t.index ["poll_id"], name: "index_poll_ballot_sheets_on_poll_id", using: :btree
  end

  create_table "poll_ballots", force: :cascade do |t|
    t.integer  "ballot_sheet_id"
    t.text     "data"
    t.integer  "external_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "poll_booth_assignments", force: :cascade do |t|
    t.integer  "booth_id"
    t.integer  "poll_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booth_id"], name: "index_poll_booth_assignments_on_booth_id", using: :btree
    t.index ["poll_id"], name: "index_poll_booth_assignments_on_poll_id", using: :btree
  end

  create_table "poll_booths", force: :cascade do |t|
    t.string  "name"
    t.string  "location"
    t.boolean "physical", default: true
  end

  create_table "poll_final_recounts", force: :cascade do |t|
    t.integer  "booth_assignment_id"
    t.integer  "officer_assignment_id"
    t.integer  "count"
    t.text     "count_log",                 default: ""
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.text     "officer_assignment_id_log", default: ""
    t.date     "date",                                        null: false
    t.string   "origin",                    default: "booth"
    t.index ["booth_assignment_id"], name: "index_poll_final_recounts_on_booth_assignment_id", using: :btree
    t.index ["officer_assignment_id"], name: "index_poll_final_recounts_on_officer_assignment_id", using: :btree
  end

  create_table "poll_letter_officer_logs", force: :cascade do |t|
    t.string   "document_number"
    t.string   "message"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "postal_code"
    t.string   "census_name"
    t.string   "census_postal_code"
  end

  create_table "poll_nvotes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "poll_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.string   "nvotes_poll_id"
    t.string   "voter_hash"
    t.integer  "officer_assignment_id"
    t.integer  "booth_assignment_id"
    t.index ["deleted_at"], name: "index_poll_nvotes_on_deleted_at", using: :btree
    t.index ["user_id"], name: "index_poll_nvotes_on_user_id", using: :btree
    t.index ["voter_hash"], name: "index_poll_nvotes_on_voter_hash", using: :btree
  end

  create_table "poll_officer_assignments", force: :cascade do |t|
    t.integer  "booth_assignment_id"
    t.integer  "officer_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.date     "date",                                null: false
    t.boolean  "final",               default: false
    t.string   "user_data_log",       default: ""
    t.index ["booth_assignment_id"], name: "index_poll_officer_assignments_on_booth_assignment_id", using: :btree
    t.index ["officer_id"], name: "index_poll_officer_assignments_on_officer_id", using: :btree
  end

  create_table "poll_officers", force: :cascade do |t|
    t.integer "user_id"
    t.integer "failed_census_calls_count", default: 0
    t.boolean "letter_officer",            default: false
    t.index ["user_id"], name: "index_poll_officers_on_user_id", using: :btree
  end

  create_table "poll_pair_answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "author_id"
    t.integer  "answer_rigth_id"
    t.integer  "answer_left_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["answer_left_id"], name: "index_poll_pair_answers_on_answer_left_id", using: :btree
    t.index ["answer_rigth_id"], name: "index_poll_pair_answers_on_answer_rigth_id", using: :btree
    t.index ["author_id"], name: "index_poll_pair_answers_on_author_id", using: :btree
    t.index ["question_id"], name: "index_poll_pair_answers_on_question_id", using: :btree
  end

  create_table "poll_partial_results", force: :cascade do |t|
    t.integer "question_id"
    t.integer "author_id"
    t.string  "answer"
    t.integer "amount"
    t.string  "origin"
    t.date    "date"
    t.integer "booth_assignment_id"
    t.integer "officer_assignment_id"
    t.text    "amount_log",                default: ""
    t.text    "officer_assignment_id_log", default: ""
    t.text    "author_id_log",             default: ""
    t.index ["answer"], name: "index_poll_partial_results_on_answer", using: :btree
    t.index ["author_id"], name: "index_poll_partial_results_on_author_id", using: :btree
    t.index ["booth_assignment_id", "date"], name: "index_poll_partial_results_on_booth_assignment_id_and_date", using: :btree
    t.index ["origin"], name: "index_poll_partial_results_on_origin", using: :btree
    t.index ["question_id"], name: "index_poll_partial_results_on_question_id", using: :btree
  end

  create_table "poll_question_answer_translations", force: :cascade do |t|
    t.integer  "poll_question_answer_id", null: false
    t.string   "locale",                  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "title"
    t.text     "description"
    t.index ["locale"], name: "index_poll_question_answer_translations_on_locale", using: :btree
    t.index ["poll_question_answer_id"], name: "index_85270fa85f62081a3a227186b4c95fe4f7fa94b9", using: :btree
  end

  create_table "poll_question_answer_videos", force: :cascade do |t|
    t.string  "title"
    t.string  "url"
    t.integer "answer_id"
    t.index ["answer_id"], name: "index_poll_question_answer_videos_on_answer_id", using: :btree
  end

  create_table "poll_question_answers", force: :cascade do |t|
    t.integer "question_id"
    t.integer "given_order", default: 1
    t.boolean "most_voted",  default: false
    t.boolean "hidden",      default: false
    t.index ["question_id"], name: "index_poll_question_answers_on_question_id", using: :btree
  end

  create_table "poll_question_translations", force: :cascade do |t|
    t.integer  "poll_question_id", null: false
    t.string   "locale",           null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "title"
    t.index ["locale"], name: "index_poll_question_translations_on_locale", using: :btree
    t.index ["poll_question_id"], name: "index_poll_question_translations_on_poll_question_id", using: :btree
  end

  create_table "poll_questions", force: :cascade do |t|
    t.integer  "proposal_id"
    t.integer  "poll_id"
    t.integer  "author_id"
    t.string   "author_visible_name"
    t.integer  "comments_count"
    t.datetime "hidden_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.tsvector "tsv"
    t.string   "video_url"
    t.index ["author_id"], name: "index_poll_questions_on_author_id", using: :btree
    t.index ["poll_id"], name: "index_poll_questions_on_poll_id", using: :btree
    t.index ["proposal_id"], name: "index_poll_questions_on_proposal_id", using: :btree
    t.index ["tsv"], name: "index_poll_questions_on_tsv", using: :gin
  end

  create_table "poll_recounts", force: :cascade do |t|
    t.integer "author_id"
    t.string  "origin"
    t.date    "date"
    t.integer "booth_assignment_id"
    t.integer "officer_assignment_id"
    t.text    "officer_assignment_id_log", default: ""
    t.text    "author_id_log",             default: ""
    t.integer "white_amount",              default: 0
    t.text    "white_amount_log",          default: ""
    t.integer "null_amount",               default: 0
    t.text    "null_amount_log",           default: ""
    t.integer "total_amount",              default: 0
    t.text    "total_amount_log",          default: ""
    t.index ["booth_assignment_id"], name: "index_poll_recounts_on_booth_assignment_id", using: :btree
    t.index ["officer_assignment_id"], name: "index_poll_recounts_on_officer_assignment_id", using: :btree
  end

  create_table "poll_shifts", force: :cascade do |t|
    t.integer  "booth_id"
    t.integer  "officer_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "officer_name"
    t.string   "officer_email"
    t.integer  "task",          default: 0, null: false
    t.index ["booth_id", "officer_id", "date", "task"], name: "index_poll_shifts_on_booth_id_and_officer_id_and_date_and_task", unique: true, using: :btree
    t.index ["booth_id"], name: "index_poll_shifts_on_booth_id", using: :btree
    t.index ["officer_id"], name: "index_poll_shifts_on_officer_id", using: :btree
  end

  create_table "poll_translations", force: :cascade do |t|
    t.integer  "poll_id",     null: false
    t.string   "locale",      null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
    t.text     "summary"
    t.text     "description"
    t.index ["locale"], name: "index_poll_translations_on_locale", using: :btree
    t.index ["poll_id"], name: "index_poll_translations_on_poll_id", using: :btree
  end

  create_table "poll_voters", force: :cascade do |t|
    t.string   "document_number"
    t.string   "document_type"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "poll_id",               null: false
    t.integer  "booth_assignment_id"
    t.integer  "age"
    t.string   "gender"
    t.integer  "geozone_id"
    t.integer  "answer_id"
    t.integer  "officer_assignment_id"
    t.integer  "user_id"
    t.string   "origin"
    t.integer  "officer_id"
    t.string   "token"
    t.index ["booth_assignment_id"], name: "index_poll_voters_on_booth_assignment_id", using: :btree
    t.index ["document_number"], name: "index_poll_voters_on_document_number", using: :btree
    t.index ["officer_assignment_id"], name: "index_poll_voters_on_officer_assignment_id", using: :btree
    t.index ["poll_id", "document_number", "document_type"], name: "doc_by_poll", using: :btree
    t.index ["poll_id"], name: "index_poll_voters_on_poll_id", using: :btree
    t.index ["user_id"], name: "index_poll_voters_on_user_id", using: :btree
  end

  create_table "polls", force: :cascade do |t|
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean  "published",          default: false
    t.boolean  "geozone_restricted", default: false
    t.string   "nvotes_poll_id"
    t.integer  "comments_count",     default: 0
    t.integer  "author_id"
    t.datetime "hidden_at"
    t.string   "slug"
    t.boolean  "results_enabled",    default: false
    t.boolean  "stats_enabled",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "budget_id"
    t.string   "related_type"
    t.integer  "related_id"
    t.index ["budget_id"], name: "index_polls_on_budget_id", unique: true, using: :btree
    t.index ["related_type", "related_id"], name: "index_polls_on_related_type_and_related_id", using: :btree
    t.index ["starts_at", "ends_at"], name: "index_polls_on_starts_at_and_ends_at", using: :btree
  end

  create_table "probe_options", force: :cascade do |t|
    t.string  "code"
    t.string  "name"
    t.integer "probe_id"
    t.integer "probe_selections_count", default: 0
    t.integer "debate_id"
    t.integer "comments_count",         default: 0, null: false
    t.integer "topic_id"
    t.index ["debate_id"], name: "index_probe_options_on_debate_id", using: :btree
    t.index ["topic_id"], name: "index_probe_options_on_topic_id", using: :btree
  end

  create_table "probe_selections", force: :cascade do |t|
    t.integer  "probe_id"
    t.integer  "probe_option_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["probe_id"], name: "index_probe_selections_on_probe_id", using: :btree
    t.index ["probe_option_id"], name: "index_probe_selections_on_probe_option_id", using: :btree
    t.index ["user_id"], name: "index_probe_selections_on_user_id", using: :btree
  end

  create_table "probes", force: :cascade do |t|
    t.string   "codename"
    t.boolean  "selecting_allowed", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["codename"], name: "index_probes_on_codename", using: :btree
  end

  create_table "profiles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
  end

  create_table "progress_bar_translations", force: :cascade do |t|
    t.integer  "progress_bar_id", null: false
    t.string   "locale",          null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "title"
    t.index ["locale"], name: "index_progress_bar_translations_on_locale", using: :btree
    t.index ["progress_bar_id"], name: "index_progress_bar_translations_on_progress_bar_id", using: :btree
  end

  create_table "progress_bars", force: :cascade do |t|
    t.integer  "kind"
    t.integer  "percentage"
    t.integer  "progressable_id"
    t.string   "progressable_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "proposal_notifications", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "author_id"
    t.integer  "proposal_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.boolean  "moderated",         default: false
    t.datetime "hidden_at"
    t.datetime "ignored_at"
    t.datetime "confirmed_hide_at"
  end

  create_table "proposals", force: :cascade do |t|
    t.string   "title",               limit: 80
    t.text     "description"
    t.integer  "author_id"
    t.datetime "hidden_at"
    t.integer  "flags_count",                    default: 0
    t.datetime "ignored_flag_at"
    t.integer  "cached_votes_up",                default: 0
    t.integer  "comments_count",                 default: 0
    t.datetime "confirmed_hide_at"
    t.bigint   "hot_score",                      default: 0
    t.integer  "confidence_score",               default: 0
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "responsible_name",    limit: 60
    t.text     "summary"
    t.string   "video_url"
    t.tsvector "tsv"
    t.integer  "geozone_id"
    t.datetime "retired_at"
    t.string   "retired_reason"
    t.text     "retired_explanation"
    t.string   "proceeding"
    t.string   "sub_proceeding"
    t.integer  "community_id"
    t.datetime "published_at"
    t.boolean  "selected",                       default: false
    t.boolean  "comunity_hide",                  default: false
    t.index ["author_id", "hidden_at"], name: "index_proposals_on_author_id_and_hidden_at", using: :btree
    t.index ["author_id"], name: "index_proposals_on_author_id", using: :btree
    t.index ["cached_votes_up"], name: "index_proposals_on_cached_votes_up", using: :btree
    t.index ["community_id"], name: "index_proposals_on_community_id", using: :btree
    t.index ["confidence_score"], name: "index_proposals_on_confidence_score", using: :btree
    t.index ["geozone_id"], name: "index_proposals_on_geozone_id", using: :btree
    t.index ["hidden_at"], name: "index_proposals_on_hidden_at", using: :btree
    t.index ["hot_score"], name: "index_proposals_on_hot_score", using: :btree
    t.index ["proceeding"], name: "index_proposals_on_proceeding", using: :btree
    t.index ["sub_proceeding"], name: "index_proposals_on_sub_proceeding", using: :btree
    t.index ["summary"], name: "index_proposals_on_summary", using: :btree
    t.index ["title"], name: "index_proposals_on_title", using: :btree
    t.index ["tsv"], name: "index_proposals_on_tsv", using: :gin
  end

  create_table "redeemable_codes", force: :cascade do |t|
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_redeemable_codes_on_token", using: :btree
  end

  create_table "related_content_scores", force: :cascade do |t|
    t.integer "user_id"
    t.integer "related_content_id"
    t.integer "value"
    t.index ["related_content_id"], name: "index_related_content_scores_on_related_content_id", using: :btree
    t.index ["user_id", "related_content_id"], name: "unique_user_related_content_scoring", unique: true, using: :btree
    t.index ["user_id"], name: "index_related_content_scores_on_user_id", using: :btree
  end

  create_table "related_contents", force: :cascade do |t|
    t.integer  "parent_relationable_id"
    t.string   "parent_relationable_type"
    t.integer  "child_relationable_id"
    t.string   "child_relationable_type"
    t.integer  "related_content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "hidden_at"
    t.integer  "related_content_scores_count", default: 0
    t.integer  "author_id"
    t.index ["child_relationable_type", "child_relationable_id"], name: "index_related_contents_on_child_relationable", using: :btree
    t.index ["hidden_at"], name: "index_related_contents_on_hidden_at", using: :btree
    t.index ["parent_relationable_id", "parent_relationable_type", "child_relationable_id", "child_relationable_type"], name: "unique_parent_child_related_content", unique: true, using: :btree
    t.index ["parent_relationable_type", "parent_relationable_id"], name: "index_related_contents_on_parent_relationable", using: :btree
    t.index ["related_content_id"], name: "opposite_related_content", using: :btree
  end

  create_table "reports", force: :cascade do |t|
    t.boolean  "stats"
    t.boolean  "results"
    t.string   "process_type"
    t.integer  "process_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.boolean  "advanced_stats"
    t.boolean  "executions",     default: true
    t.index ["process_type", "process_id"], name: "index_reports_on_process_type_and_process_id", using: :btree
  end

  create_table "section_administrators", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_section_administrators_on_user_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string  "key"
    t.string  "value"
    t.boolean "permit_html_safe", default: false
    t.index ["key"], name: "index_settings_on_key", using: :btree
  end

  create_table "sg_generics", force: :cascade do |t|
    t.string   "title"
    t.string   "generic_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "sg_selects", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.jsonb    "data"
    t.integer  "sg_setting_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["sg_setting_id"], name: "index_sg_selects_on_sg_setting_id", using: :btree
  end

  create_table "sg_settings", force: :cascade do |t|
    t.string   "title"
    t.string   "setting_type"
    t.string   "data_type"
    t.boolean  "active"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "sg_table_fields", force: :cascade do |t|
    t.string   "table_name"
    t.string   "field_name"
    t.string   "sgeneric_type"
    t.integer  "sgeneric_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["sgeneric_type", "sgeneric_id"], name: "index_sg_table_fields_on_sgeneric_type_and_sgeneric_id", using: :btree
  end

  create_table "sg_table_orders", force: :cascade do |t|
    t.string   "table_name"
    t.integer  "order",         default: 0
    t.integer  "sg_generic_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["sg_generic_id"], name: "index_sg_table_orders_on_sg_generic_id", using: :btree
  end

  create_table "signature_sheets", force: :cascade do |t|
    t.integer  "signable_id"
    t.string   "signable_type"
    t.text     "document_numbers"
    t.boolean  "processed",        default: false
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signatures", force: :cascade do |t|
    t.integer  "signature_sheet_id"
    t.integer  "user_id"
    t.string   "document_number"
    t.boolean  "verified",           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_customization_content_blocks", force: :cascade do |t|
    t.string   "name"
    t.string   "locale"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "locale"], name: "index_site_customization_content_blocks_on_name_and_locale", unique: true, using: :btree
  end

  create_table "site_customization_images", force: :cascade do |t|
    t.string   "name",               null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["name"], name: "index_site_customization_images_on_name", unique: true, using: :btree
  end

  create_table "site_customization_page_translations", force: :cascade do |t|
    t.integer  "site_customization_page_id", null: false
    t.string   "locale",                     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "title"
    t.string   "subtitle"
    t.text     "content"
    t.index ["locale"], name: "index_site_customization_page_translations_on_locale", using: :btree
    t.index ["site_customization_page_id"], name: "index_7fa0f9505738cb31a31f11fb2f4c4531fed7178b", using: :btree
  end

  create_table "site_customization_pages", force: :cascade do |t|
    t.string   "slug",                                 null: false
    t.boolean  "more_info_flag"
    t.boolean  "print_content_flag"
    t.string   "status",             default: "draft"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "locale"
  end

  create_table "stats", force: :cascade do |t|
    t.string   "namespace"
    t.string   "group"
    t.string   "name"
    t.integer  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["namespace", "group"], name: "index_stats_on_namespace_and_group", using: :btree
    t.index ["namespace"], name: "index_stats_on_namespace", using: :btree
  end

  create_table "stats_versions", force: :cascade do |t|
    t.string   "process_type"
    t.integer  "process_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["process_type", "process_id"], name: "index_stats_versions_on_process_type_and_process_id", using: :btree
  end

  create_table "superadministrators", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_superadministrators_on_user_id", using: :btree
  end

  create_table "sures_actuation_translations", force: :cascade do |t|
    t.integer  "sures_actuation_id",   null: false
    t.string   "locale",               null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "proposal_title"
    t.text     "proposal_objective"
    t.text     "territorial_scope"
    t.text     "location_performance"
    t.text     "technical_visibility"
    t.text     "actions_taken"
    t.index ["locale"], name: "index_sures_actuation_translations_on_locale", using: :btree
    t.index ["sures_actuation_id"], name: "index_sures_actuation_translations_on_sures_actuation_id", using: :btree
  end

  create_table "sures_actuations", force: :cascade do |t|
    t.string   "status"
    t.string   "financig_performance"
    t.boolean  "check_anno",           default: false
    t.boolean  "check_multianno",      default: false
    t.string   "annos"
    t.string   "tracking"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "borought"
    t.string   "other"
    t.jsonb    "geozones"
    t.string   "project"
    t.index ["geozones"], name: "index_sures_actuations_on_geozones", using: :gin
  end

  create_table "sures_administrators", force: :cascade do |t|
    t.integer "user_id"
    t.index ["user_id"], name: "index_sures_administrators_on_user_id", using: :btree
  end

  create_table "sures_customize_card_translations", force: :cascade do |t|
    t.integer  "sures_customize_card_id", null: false
    t.string   "locale",                  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "label"
    t.string   "title"
    t.text     "description"
    t.string   "link_text"
    t.index ["locale"], name: "index_sures_customize_card_translations_on_locale", using: :btree
    t.index ["sures_customize_card_id"], name: "index_a5b2f928f909372aebe48d55c60ea154c06a6816", using: :btree
  end

  create_table "sures_customize_cards", force: :cascade do |t|
    t.string   "link_url"
    t.boolean  "header",                     default: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "site_customization_page_id"
    t.integer  "columns",                    default: 4
    t.string   "position_image",             default: "left"
    t.index ["site_customization_page_id"], name: "index_sures_customize_cards_on_site_customization_page_id", using: :btree
  end

  create_table "sures_search_settings", force: :cascade do |t|
    t.string   "title"
    t.string   "data_type"
    t.string   "data"
    t.string   "resource"
    t.string   "field"
    t.string   "rules"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "active",      default: true
    t.string   "data_status"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name",                        limit: 160
    t.integer "taggings_count",                          default: 0
    t.integer "debates_count",                           default: 0
    t.integer "proposals_count",                         default: 0
    t.string  "kind"
    t.integer "budget/investments_count",                default: 0
    t.integer "legislation/proposals_count",             default: 0
    t.integer "legislation/processes_count",             default: 0
    t.index ["debates_count"], name: "index_tags_on_debates_count", using: :btree
    t.index ["legislation/processes_count"], name: "index_tags_on_legislation/processes_count", using: :btree
    t.index ["legislation/proposals_count"], name: "index_tags_on_legislation/proposals_count", using: :btree
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
    t.index ["proposals_count"], name: "index_tags_on_proposals_count", using: :btree
  end

  create_table "topics", force: :cascade do |t|
    t.string   "title",                          null: false
    t.text     "description"
    t.integer  "author_id"
    t.integer  "comments_count",     default: 0
    t.integer  "community_id"
    t.datetime "hidden_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "cached_votes_total", default: 0
    t.integer  "cached_votes_up",    default: 0
    t.integer  "cached_votes_down",  default: 0
    t.integer  "cached_votes_score", default: 0
    t.bigint   "hot_score",          default: 0
    t.integer  "confidence_score",   default: 0
    t.integer  "flags_count",        default: 0
    t.datetime "ignored_flag_at"
    t.datetime "confirmed_hide_at"
    t.index ["cached_votes_down"], name: "index_topics_on_cached_votes_down", using: :btree
    t.index ["cached_votes_score"], name: "index_topics_on_cached_votes_score", using: :btree
    t.index ["cached_votes_total"], name: "index_topics_on_cached_votes_total", using: :btree
    t.index ["cached_votes_up"], name: "index_topics_on_cached_votes_up", using: :btree
    t.index ["community_id"], name: "index_topics_on_community_id", using: :btree
    t.index ["confidence_score"], name: "index_topics_on_confidence_score", using: :btree
    t.index ["hidden_at"], name: "index_topics_on_hidden_at", using: :btree
  end

  create_table "trackers", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "description"
    t.integer  "budget_investment_count", default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["user_id"], name: "index_trackers_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                      default: ""
    t.string   "encrypted_password",                         default: "",                    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                              default: 0,                     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                                                 null: false
    t.datetime "updated_at",                                                                 null: false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "email_on_comment",                           default: false
    t.boolean  "email_on_comment_reply",                     default: false
    t.string   "phone_number",                   limit: 30
    t.string   "official_position"
    t.integer  "official_level",                             default: 0
    t.datetime "hidden_at"
    t.string   "sms_confirmation_code"
    t.string   "username",                       limit: 120
    t.string   "document_number"
    t.string   "document_type"
    t.datetime "residence_verified_at"
    t.string   "email_verification_token"
    t.datetime "verified_at"
    t.string   "unconfirmed_phone"
    t.string   "confirmed_phone"
    t.datetime "letter_requested_at"
    t.datetime "confirmed_hide_at"
    t.string   "letter_verification_code"
    t.integer  "failed_census_calls_count",                  default: 0
    t.datetime "level_two_verified_at"
    t.string   "erase_reason"
    t.datetime "erased_at"
    t.boolean  "public_activity",                            default: true
    t.boolean  "newsletter",                                 default: true
    t.integer  "notifications_count",                        default: 0
    t.boolean  "registering_with_oauth",                     default: false
    t.string   "locale"
    t.string   "oauth_email"
    t.integer  "geozone_id"
    t.string   "redeemable_code"
    t.string   "gender",                         limit: 10
    t.datetime "date_of_birth"
    t.boolean  "email_on_proposal_notification",             default: true
    t.boolean  "email_digest",                               default: true
    t.boolean  "email_on_direct_message",                    default: true
    t.boolean  "official_position_badge",                    default: false
    t.datetime "password_changed_at",                        default: '2015-01-01 01:01:01', null: false
    t.boolean  "created_from_signature",                     default: false
    t.integer  "failed_email_digests_count",                 default: 0
    t.boolean  "officing_voter",                             default: false
    t.text     "former_users_data_log",                      default: ""
    t.integer  "balloted_heading_id"
    t.boolean  "public_interests",                           default: false
    t.boolean  "recommended_debates",                        default: true
    t.boolean  "recommended_proposals",                      default: true
    t.string   "newsletter_token"
    t.datetime "newsletter_token_used_at"
    t.integer  "failed_attempts",                            default: 0,                     null: false
    t.datetime "locked_at"
    t.text     "access_key_generated"
    t.text     "access_key_inserted"
    t.date     "access_key_generated_at"
    t.integer  "access_key_tried",                           default: 0
    t.date     "date_hide"
    t.string   "name"
    t.string   "last_name"
    t.string   "last_name_alt"
    t.integer  "adress_id"
    t.integer  "profiles_id"
    t.index ["adress_id"], name: "index_users_on_adress_id", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["geozone_id"], name: "index_users_on_geozone_id", using: :btree
    t.index ["hidden_at"], name: "index_users_on_hidden_at", using: :btree
    t.index ["password_changed_at"], name: "index_users_on_password_changed_at", using: :btree
    t.index ["profiles_id"], name: "index_users_on_profiles_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", using: :btree
  end

  create_table "valuator_groups", force: :cascade do |t|
    t.string  "name"
    t.integer "budget_investments_count", default: 0
  end

  create_table "valuators", force: :cascade do |t|
    t.integer "user_id"
    t.string  "description"
    t.integer "budget_investments_count", default: 0
    t.integer "valuator_group_id"
    t.boolean "can_comment",              default: true
    t.boolean "can_edit_dossier",         default: true
    t.index ["user_id"], name: "index_valuators_on_user_id", using: :btree
  end

  create_table "verified_users", force: :cascade do |t|
    t.string   "document_number"
    t.string   "document_type"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["document_number"], name: "index_verified_users_on_document_number", using: :btree
    t.index ["email"], name: "index_verified_users_on_email", using: :btree
    t.index ["phone"], name: "index_verified_users_on_phone", using: :btree
  end

  create_table "visits", id: :uuid, default: nil, force: :cascade do |t|
    t.uuid     "visitor_id"
    t.string   "ip"
    t.text     "user_agent"
    t.text     "referrer"
    t.text     "landing_page"
    t.integer  "user_id"
    t.string   "referring_domain"
    t.string   "search_keyword"
    t.string   "browser"
    t.string   "os"
    t.string   "device_type"
    t.integer  "screen_height"
    t.integer  "screen_width"
    t.string   "country"
    t.string   "region"
    t.string   "city"
    t.string   "postal_code"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "utm_source"
    t.string   "utm_medium"
    t.string   "utm_term"
    t.string   "utm_content"
    t.string   "utm_campaign"
    t.datetime "started_at"
    t.index ["started_at"], name: "index_visits_on_started_at", using: :btree
    t.index ["user_id"], name: "index_visits_on_user_id", using: :btree
  end

  create_table "volunteer_polls", force: :cascade do |t|
    t.string  "email"
    t.string  "turns"
    t.boolean "any_district"
    t.boolean "arganzuela"
    t.boolean "barajas"
    t.boolean "carabanchel"
    t.boolean "centro"
    t.boolean "chamartin"
    t.boolean "chamberi"
    t.boolean "ciudad_lineal"
    t.boolean "fuencarral_el_pardo"
    t.boolean "hortaleza"
    t.boolean "latina"
    t.boolean "moncloa_aravaca"
    t.boolean "moratalaz"
    t.boolean "puente_de_vallecas"
    t.boolean "retiro"
    t.boolean "salamanca"
    t.boolean "san_blas_canillejas"
    t.boolean "tetuan"
    t.boolean "usera"
    t.boolean "vicalvaro"
    t.boolean "villa_de_vallecas"
    t.boolean "villaverde"
    t.string  "first_name"
    t.string  "last_name"
    t.string  "document_number"
    t.string  "phone"
    t.boolean "monday_13_morning"
    t.boolean "monday_13_afternoon"
    t.boolean "tuesday_14_morning"
    t.boolean "tuesday_14_afternoon"
    t.boolean "wednesday_15_morning"
    t.boolean "wednesday_15_afternoon"
    t.boolean "thursday_16_morning"
    t.boolean "thursday_16_afternoon"
    t.boolean "friday_17_morning"
    t.boolean "friday_17_afternoon"
    t.boolean "saturday_18_morning"
    t.boolean "saturday_18_afternoon"
    t.boolean "sunday_19_morning"
    t.boolean "sunday_19_afternoon"
    t.boolean "monday_20_morning"
  end

  create_table "votation_set_answers", force: :cascade do |t|
    t.integer  "author_id"
    t.integer  "votation_type_id"
    t.string   "answer"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["author_id"], name: "index_votation_set_answers_on_author_id", using: :btree
    t.index ["votation_type_id"], name: "index_votation_set_answers_on_votation_type_id", using: :btree
  end

  create_table "votation_types", force: :cascade do |t|
    t.integer  "questionable_id"
    t.string   "questionable_type"
    t.integer  "enum_type"
    t.boolean  "open_answer"
    t.boolean  "prioritized"
    t.integer  "prioritization_type"
    t.integer  "max_votes"
    t.integer  "max_groups_answers"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "signature_id"
    t.index ["signature_id"], name: "index_votes_on_signature_id", using: :btree
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  end

  create_table "web_sections", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "widget_card_translations", force: :cascade do |t|
    t.integer  "widget_card_id", null: false
    t.string   "locale",         null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "label"
    t.string   "title"
    t.text     "description"
    t.string   "link_text"
    t.index ["locale"], name: "index_widget_card_translations_on_locale", using: :btree
    t.index ["widget_card_id"], name: "index_widget_card_translations_on_widget_card_id", using: :btree
  end

  create_table "widget_cards", force: :cascade do |t|
    t.string   "link_url"
    t.boolean  "header",                     default: false
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "site_customization_page_id"
    t.integer  "columns",                    default: 4
    t.index ["site_customization_page_id"], name: "index_widget_cards_on_site_customization_page_id", using: :btree
  end

  create_table "widget_feeds", force: :cascade do |t|
    t.string   "kind"
    t.integer  "limit",      default: 3
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_foreign_key "actuations_multi_years", "sures_actuations", column: "sures_actuations_id"
  add_foreign_key "administrators", "users"
  add_foreign_key "adresses", "users", column: "users_id"
  add_foreign_key "budget_administrators", "administrators"
  add_foreign_key "budget_administrators", "budgets"
  add_foreign_key "budget_investments", "communities"
  add_foreign_key "complan_activities", "complan_performances"
  add_foreign_key "complan_ambits", "complan_performances"
  add_foreign_key "complan_assistants", "complan_people"
  add_foreign_key "complan_assistants", "complan_thecnical_tables"
  add_foreign_key "complan_beneficiaries", "complan_performances"
  add_foreign_key "complan_beneficiaries_typologies", "complan_beneficiaries"
  add_foreign_key "complan_beneficiaries_typologies", "complan_typologies"
  add_foreign_key "complan_credit_modifications", "complan_imports"
  add_foreign_key "complan_editors", "users"
  add_foreign_key "complan_files", "complan_financings"
  add_foreign_key "complan_imports", "complan_centers"
  add_foreign_key "complan_imports", "complan_financings"
  add_foreign_key "complan_indicators", "complan_performances"
  add_foreign_key "complan_locations", "complan_financings"
  add_foreign_key "complan_medias", "complan_performances"
  add_foreign_key "complan_people", "complan_centers"
  add_foreign_key "complan_performances", "complan_financings"
  add_foreign_key "complan_performances", "complan_projects"
  add_foreign_key "complan_projects", "complan_strategies"
  add_foreign_key "complan_readers", "users"
  add_foreign_key "complan_thecnical_tables", "complan_performances"
  add_foreign_key "complan_trackings", "complan_performances"
  add_foreign_key "consultants", "users"
  add_foreign_key "custom_pages", "users"
  add_foreign_key "dashboard_administrator_tasks", "users"
  add_foreign_key "dashboard_executed_actions", "dashboard_actions", column: "action_id"
  add_foreign_key "dashboard_executed_actions", "proposals"
  add_foreign_key "documents", "users"
  add_foreign_key "editors", "users"
  add_foreign_key "failed_census_calls", "poll_officers"
  add_foreign_key "failed_census_calls", "users"
  add_foreign_key "flags", "users"
  add_foreign_key "follows", "users"
  add_foreign_key "geozones_legislation_processes", "geozones"
  add_foreign_key "geozones_legislation_processes", "legislation_processes"
  add_foreign_key "geozones_polls", "geozones"
  add_foreign_key "geozones_polls", "polls"
  add_foreign_key "identities", "users"
  add_foreign_key "images", "users"
  add_foreign_key "legislation_cat_prop", "legislation_categories", column: "category_id"
  add_foreign_key "legislation_cat_prop", "legislation_proposals", column: "proposal_id"
  add_foreign_key "legislation_categories", "legislation_processes"
  add_foreign_key "legislation_draft_versions", "legislation_processes"
  add_foreign_key "legislation_proposals", "legislation_other_proposals"
  add_foreign_key "legislation_proposals", "legislation_processes"
  add_foreign_key "locks", "users"
  add_foreign_key "managers", "users"
  add_foreign_key "menu_items", "menus"
  add_foreign_key "menus", "users"
  add_foreign_key "moderators", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "organizations", "users"
  add_foreign_key "parbudget_assistants", "parbudget_meetings"
  add_foreign_key "parbudget_centers", "parbudget_projects"
  add_foreign_key "parbudget_economic_budgets", "parbudget_projects"
  add_foreign_key "parbudget_editors", "users"
  add_foreign_key "parbudget_links", "parbudget_projects"
  add_foreign_key "parbudget_medias", "parbudget_projects"
  add_foreign_key "parbudget_projects", "parbudget_ambits"
  add_foreign_key "parbudget_projects", "parbudget_responsibles"
  add_foreign_key "parbudget_projects", "parbudget_topics"
  add_foreign_key "parbudget_readers", "users"
  add_foreign_key "parbudget_responsibles", "parbudget_centers"
  add_foreign_key "parbudget_track_exts", "parbudget_tracking_externals"
  add_foreign_key "parbudget_track_exts", "parbudget_trackings"
  add_foreign_key "parbudget_track_ints", "parbudget_tracking_internals"
  add_foreign_key "parbudget_track_ints", "parbudget_trackings"
  add_foreign_key "parbudget_trackings", "parbudget_projects"
  add_foreign_key "parbudget_trackings_meetings", "parbudget_meetings"
  add_foreign_key "parbudget_trackings_meetings", "parbudget_trackings"
  add_foreign_key "poll_answers", "poll_questions", column: "question_id"
  add_foreign_key "poll_booth_assignments", "polls"
  add_foreign_key "poll_final_recounts", "poll_booth_assignments", column: "booth_assignment_id"
  add_foreign_key "poll_final_recounts", "poll_officer_assignments", column: "officer_assignment_id"
  add_foreign_key "poll_nvotes", "poll_booth_assignments", column: "booth_assignment_id"
  add_foreign_key "poll_nvotes", "poll_officer_assignments", column: "officer_assignment_id"
  add_foreign_key "poll_officer_assignments", "poll_booth_assignments", column: "booth_assignment_id"
  add_foreign_key "poll_partial_results", "poll_booth_assignments", column: "booth_assignment_id"
  add_foreign_key "poll_partial_results", "poll_officer_assignments", column: "officer_assignment_id"
  add_foreign_key "poll_partial_results", "poll_questions", column: "question_id"
  add_foreign_key "poll_partial_results", "users", column: "author_id"
  add_foreign_key "poll_question_answer_videos", "poll_question_answers", column: "answer_id"
  add_foreign_key "poll_question_answers", "poll_questions", column: "question_id"
  add_foreign_key "poll_questions", "polls"
  add_foreign_key "poll_questions", "proposals"
  add_foreign_key "poll_questions", "users", column: "author_id"
  add_foreign_key "poll_recounts", "poll_booth_assignments", column: "booth_assignment_id"
  add_foreign_key "poll_recounts", "poll_officer_assignments", column: "officer_assignment_id"
  add_foreign_key "poll_voters", "polls"
  add_foreign_key "polls", "budgets"
  add_foreign_key "probe_options", "debates"
  add_foreign_key "probe_options", "topics"
  add_foreign_key "proposals", "communities"
  add_foreign_key "related_content_scores", "related_contents"
  add_foreign_key "related_content_scores", "users"
  add_foreign_key "section_administrators", "users"
  add_foreign_key "sg_selects", "sg_settings"
  add_foreign_key "sg_table_orders", "sg_generics"
  add_foreign_key "superadministrators", "users"
  add_foreign_key "sures_administrators", "users"
  add_foreign_key "trackers", "users"
  add_foreign_key "users", "adresses"
  add_foreign_key "users", "geozones"
  add_foreign_key "users", "profiles", column: "profiles_id"
  add_foreign_key "valuators", "users"
  add_foreign_key "votation_set_answers", "votation_types"
end
