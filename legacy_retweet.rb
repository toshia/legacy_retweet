# frozen_string_literal: true

Plugin.create(:legacy_retweet) do
  command(:legacy_retweet,
          name: '非公式リツイート',
          condition: ->(opt) { opt.messages.size == 1 && compose?(opt.world, to: opt.messages) },
          visible: true,
          role: :timeline) do |opt|
    m = opt.messages.first
    opt.widget.create_postbox(to: [m],
                              footer: " RT @#{m.idname}: #{m.description}",
                              to_display_only: !UserConfig[:legacy_retweet_act_as_reply],
                              use_blind_footer: !UserConfig[:footer_exclude_retweet])
  end

  settings '非公式リツイート' do
    boolean('非公式リツイートにin_reply_to_statusを付与する', :legacy_retweet_act_as_reply)
      .tooltip(<<~TIPHELP)
        チェックされた場合、非公式リツイートのリプライ先として、元の投稿を指定します。
        非公式RTの宛先に到達できるようになりますが、公開範囲がリプライと同じになります。
      TIPHELP
    boolean('非公式リツイートの場合はフッタを付与しない', :footer_exclude_retweet)
      .tooltip('関係ないけど、ツールチップってあんまり役に立つこと書いてないし、後ろ見えないし邪魔ですよねぇ')
  end
end
