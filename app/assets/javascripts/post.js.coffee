jQuery ->
  availableTags = $('#q_topik_cont').data('autocomplete-source')
  split = (val) ->
    val.split /,\s*/
  extractLast = (term) ->
    split(term).pop()
  $('#q_topik_cont').bind('keydown', (event) ->
    if event.keyCode == $.ui.keyCode.TAB and $(this).autocomplete('instance').menu.active
      event.preventDefault()
    return
  ).autocomplete
    minLength: 0
    source: (request, response) ->
      response $.ui.autocomplete.filter(availableTags, extractLast(request.term))
      return
    focus: ->
      false
    select: (event, ui) ->
      terms = split(@value)
      terms.pop()
      terms.push ui.item.value
      terms.push ''
      @value = terms.join(', ')
      false


  $('#myModal').on 'shown.bs.modal', (e) ->
    $('#myInput').focus()
    $invoker = $(e.relatedTarget)
    code = '\
    <button aria-label="Close" class="close" data-dismiss="modal" type="button">
      <span aria-hidden="true">×</span>
    </button>
    <br />'
    code += '<img src ="' + $invoker[0].src + '"</img>'
    $('.modal-body').html(code)

  $('#myModal').on 'hidden.bs.modal', ->
    $('.modal-body').html('')
    return