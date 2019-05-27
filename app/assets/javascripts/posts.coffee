# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'ready page:load', ->
  $('#post-tags').tagit
    fieldName:   'post[tag_list]'
    singleField: true
    # 作成済みのタグを自動補完
    availableTags: gon.available_tags
  $('#post-tags').tagit (
    # 編集画面での関連するのタグを入力欄に入力する
    if gon.post_tags?
      for tag in gon.post_tags
        $('#post-tags').tagit('createTag', tag);
  );

  $('#post-links').tagit
    fieldName:   'post[link_list]'
    singleField: true
    # 作成済みのリンクを自動補完
    availableTags: gon.available_links
  $('#post-link').tagit (
    # 編集画面での関連するのタグを入力欄に入力する
    if gon.post_links?
      for tag in gon.post_links
        $('#post-links').tagit('createTag', tag);
  );






