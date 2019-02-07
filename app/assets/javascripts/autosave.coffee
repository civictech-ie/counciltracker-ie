saveChanges = (form) ->
  $('[data-bind="autosaveTimestamp"]').text 'Saving...'
  data = form.serialize()
  $.ajax
    type: 'patch'
    url: form.attr('action')
    dataType: 'json'
    data: form.serialize()
    success: (data) ->
      $('[data-bind="autosaveTimestamp"]').text data['message']

$(document).on 'turbolinks:load', ->
  $('form[data-action="autosave"]').on 'change', '[type="checkbox"]', (e) ->
    checkboxEl = $(e.target)
    formEl = checkboxEl.parents('form').first()
    liEl = checkboxEl.parents('.row').first()

    if checkboxEl.is(':checked')
      val = checkboxEl.data('value')
      for checkbox in $('[type="checkbox"]', liEl)
        if $(checkbox).data('value') isnt val
          $(checkbox).prop('checked', false)

    else
      val = 'exception'

    $('[data-bind="checkboxes"]', liEl).val(val)
    saveChanges(formEl)
