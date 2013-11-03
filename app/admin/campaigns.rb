ActiveAdmin.register Campaign do
  platform_label = "Platform(s)"

  index do
    column :name
    column :budget
    column platform_label, class: :platform do |campaign|
      campaign.platforms.map(&:name).join(", ")
    end
    actions
  end

  show do |campaign|
    attributes_table do
      row :id
      row :name
      row :budget
      row platform_label, :platforms do
        campaign.platforms.map(&:name).join(", ")
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :name, required: true
      f.input :budget, required: true
      f.input :platforms, as: :check_boxes, collection: Platform.all,
              label: platform_label, required: true
    end
    f.actions
  end
end
