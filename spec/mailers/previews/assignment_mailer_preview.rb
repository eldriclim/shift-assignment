# Preview all emails at http://localhost:3000/rails/mailers/assignment_mailer
class AssignmentMailerPreview < ActionMailer::Preview
  def assignment_notice
    assignment = Assignment.first

    AssignmentMailer.with(
      user: assignment.deliverer,
      shift: assignment.shift,
      assignment: assignment
    ).assignment_notice
  end
end
