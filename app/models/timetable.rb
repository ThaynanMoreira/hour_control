class Timetable < ActiveRecord::Base

	belongs_to :project

	belongs_to :type
  
  
  
	attr_accessible  :project_id, :type_id, :hours_amount, :hours_completed, :observation, :month, :year
	#attr_accessor :project_id, :type_id, :hours_amount, :hours_completed

  validates :hours_amount, :presence => true
  validates :month,        :presence => true
  validates :year,         :presence => true
  
  def get_hours_completed(date)
    temp_hours_completed = self.hours_completed
    self.hours_completed = 0
    @historics = self.project.historics.where(:work_date => (date.beginning_of_month..date.end_of_month))

    for historic in @historics
      self.hours_completed += historic.hours_used
    end

    if temp_hours_completed != self.hours_completed
      self.save!
    end

    return self.hours_completed
  end

  def verify_hours
    @notice = [:alert => "Faltam poucas semanas para as horas acabarem"]
      dif_hours = self.hours_amount - self.get_hours_completed(Time.now)
      if (dif_hours < 30)

      if (dif_hours > 10)
        @notice = [:alert => "Faltam poucas semanas para as horas acabarem"]
      else

      if (dif_hours < 10 )
        @notice = [:error => "Poucas horas"]

      end
      end
      else
        @notice = [:success => "Pode trabalhar"]
      end
    @notice
   end


end
