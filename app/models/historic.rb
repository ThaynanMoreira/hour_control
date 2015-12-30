class Historic < ActiveRecord::Base

	belongs_to :user
	belongs_to :project
  belongs_to :task
  belongs_to :type

  attr_accessible :user_id, :hours_used, :project_id, :work_date, :enter_work, :exit_work, :comment, :task_id, :type_id


  default_scope order('work_date DESC')
	validates :user_id,    :presence => true
	validates :type_id,    :presence => true
	validates :hours_used, :presence => true
	validates :project_id, :presence => true
  validates :work_date,  :presence => true
  validates :enter_work, :presence => true
  validates :exit_work,  :presence => true



  def self.get_hour(float)

    hour = 0
    minute = 0

    if(float.round < float)
      hour = float.round
      minute = ((float - hour)*1.minute).round
      if hour.to_s.length<2
        f = "0#{hour}"
      else
        f = hour
      end

      if minute.to_s.length<2
        m = "0#{minute}"
      else
        m = minute
      end
      return "#{f}:#{m}"
    else
      if(float.round > float)
        hour = float.round - 1
        minute = ((float - hour)*1.minute).round

        if hour.to_s.length<2
          f = "0#{hour}"
        else
          f = hour
        end

        if minute.to_s.length<2
          m = "0#{minute}"
        else
          m = minute
        end

        return "#{f}:#{m}"
      else
        if float.round.to_s.length<2
          f = "0#{float.round}"
        else
          f = float.round
        end
        return "#{f}:00"
      end
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |historic|
        csv << historic.attributes.values_at(*column_names)
      end
    end
  end


  private

  
end
