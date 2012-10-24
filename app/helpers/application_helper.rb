module ApplicationHelper
	def add_task_link(name)
		link_to name, "#", "data-partial" => h(render(:partial => 'sys', :object => @add_dev.syss.new)), :class => 'add_dev'
	end
end
