class MessagesController < ApplicationController
  def index
    @messages = Message.all.sort_by { |m| m.timestamp }
  end

  def show
    @message = Message.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])

    if @message.update_attributes(params[:message])
      redirect_to message_path(@message), :notice => "Comment sucessfully updated"
    else
      redirect_to message_path(@message), :notice => "Error updating comment"
    end
  end
end
