console.log("Yeah! The dashboard has started!")

MyDashboard.on 'ready', ->
  MyDashboard.widget_margins ||= [5, 5]
  MyDashboard.widget_base_dimensions ||= [300, 360]
  MyDashboard.numColumns ||= 4

  contentWidth = (MyDashboard.widget_base_dimensions[0] + MyDashboard.widget_margins[0] * 2) * MyDashboard.numColumns

  Batman.setImmediate ->
    $('.gridster').width(contentWidth)
    $('.gridster ul:first').gridster
      widget_margins: MyDashboard.widget_margins
      widget_base_dimensions: MyDashboard.widget_base_dimensions
      autogenerate_stylesheet: true
      min_cols: 1
      max_cols: 6
      avoid_overlapped_widgets: !MyDashboard.customGridsterLayout
      resize:
        enabled: true
      draggable:
        stop: MyDashboard.showGridsterInstructions
        start: -> MyDashboard.currentWidgetPositions = MyDashboard.getWidgetPositions()
