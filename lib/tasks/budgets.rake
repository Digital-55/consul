namespace :budgets do
  desc "Regenerate ballot_lines_count cache"
  task calculate_ballot_lines: :environment do
    ApplicationLogger.new.info "Calculating ballot lines"

    Budget::Ballot.find_each.with_index do |ballot, index|
      Budget::Ballot.reset_counters ballot.id, :lines
      print "." if (index % 10_000).zero?
    end
  end

  namespace :email do

    desc "Sends emails to authors of selected investments"
    task selected: :environment do
      Budget.current.email_selected
    end

    desc "Sends emails to authors of unselected investments"
    task unselected: :environment do
      Budget.current.email_unselected
    end

    desc "Get emails from last Budget's winner investments authors"
    task winner_investments_emails: :environment do
      puts winner_emails
    end

    desc "Get emails from last Budget's selected but not winner investments authors"
    task selected_investments_emails: :environment do
      puts selected_emails
    end

    desc "Get emails from last Budget's proposed but not selected investments authors"
    task proposed_non_selected_investments_emails: :environment do
      puts proposed_non_selected_emails
    end

  end

  desc "Get Budget Polls results to fill an excell"
  task budget_polls_results: :environment do
    require "csv"

    csv_string = CSV.generate(col_sep: "^", row_sep: "*****") do |csv|
      BudgetPoll.find_each do |budget_poll|
        csv << [
          budget_poll.name,
          budget_poll.email,
          budget_poll.preferred_subject,
          budget_poll.collective ? "Si" : "No",
          budget_poll.public_worker ? "Si" : "No",
          budget_poll.proposal_author ? "Si" : "No",
          budget_poll.selected_proposal_author ? "Si" : "No"
        ]
      end
    end

    csv_string.delete!("\t")
    headers = "nombre^email^tema^colectivo^funcionario^autor^seleccionado*****"
    puts "#{headers}#{csv_string}"
  end

  desc "Update investments original_heading_id with current heading_id"
  task set_original_heading_id: :environment do
    puts "Starting"
    Budget::Investment.find_each do |investment|
      investment.update_column(:original_heading_id, investment.heading_id)
      print "."
    end
    puts "Finished"
  end

end

def investments_author_emails(investments)
  User.where(id: investments.pluck(:author_id).uniq).pluck(:email).uniq
end

def winner_investments
  Budget::Investment.winners.where(budget: Budget.current)
end

def selected_non_winner_investments
  Budget::Investment.selected.where(budget: Budget.current)
                    .where.not(id: winner_investments.pluck(:id))
end

def non_selected_non_winner_investments
  Budget::Investment.where(budget: Budget.current)
                    .where.not(id: Budget::Investment.selected.pluck(:id))
end

def winner_emails
  investments_author_emails(winner_investments)
end

def selected_emails
  investments_author_emails(selected_non_winner_investments) - winner_emails
end

def proposed_non_selected_emails
  investments_author_emails(non_selected_non_winner_investments) - selected_emails
end
