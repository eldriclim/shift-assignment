class AssignmentMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def assignment_notice
    @user = params[:user]
    @shift = params[:shift]
    @assignment = params[:assignment]

    mail(
      to: @user.email,
      subject: 'Notice: You have been assigned a new shift!'
    )
  end
end
