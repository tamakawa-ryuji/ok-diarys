# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/navs
# frozen_string_literal: true

require 'pagy/extras/shared'

class Pagy
  module Frontend

    # Javascript pagination: it returns a nav and a JSON tag used by the Pagy.nav javascript
    def pagy_nav_js(pagy, deprecated_id=nil, pagy_id: nil, link_extra: '', steps: nil)
      pagy_id = Pagy.deprecated_arg(:id, deprecated_id, :pagy_id, pagy_id) if deprecated_id
      p_id = %( id="#{pagy_id}") if pagy_id
      link = pagy_link_proc(pagy, link_extra: link_extra)
      tags = { 'before' => pagy_nav_prev_html(pagy, link),
               'link'   => %(<span class="page">#{link.call(PAGE_PLACEHOLDER)}</span> ),
               'active' => %(<span class="page active">#{pagy.page}</span> ),
               'gap'    => %(<span class="page gap">#{pagy_t 'pagy.nav.gap'}</span> ),
               'after'  => pagy_nav_next_html(pagy, link) }

      %(<nav#{p_id} class="pagy-njs pagy-nav-js pagination" aria-label="pager" #{pagy_json_attr(pagy, :nav, tags, pagy.sequels(steps))}></nav>)
    end

    # Javascript combo pagination: it returns a nav and a JSON tag used by the Pagy.combo_nav javascript
    def pagy_combo_nav_js(pagy, deprecated_id=nil, pagy_id: nil, link_extra: '')
      pagy_id = Pagy.deprecated_arg(:id, deprecated_id, :pagy_id, pagy_id) if deprecated_id
      p_id    = %( id="#{pagy_id}") if pagy_id
      link    = pagy_link_proc(pagy, link_extra: link_extra)
      p_page  = pagy.page
      p_pages = pagy.pages
      input   = %(<input type="number" min="1" max="#{p_pages}" value="#{p_page}" style="padding: 0; text-align: center; width: #{p_pages.to_s.length+1}rem;">)

      %(<nav#{p_id} class="pagy-combo-nav-js pagination" aria-label="pager" #{
          pagy_json_attr pagy, :combo_nav, p_page, pagy_marked_link(link)
      }>#{
          pagy_nav_prev_html pagy, link
      }<span class="pagy-combo-input" style="margin: 0 0.6rem;">#{
          pagy_t 'pagy.combo_nav_js', page_input: input, count: p_page, pages: p_pages
      }</span> #{
          pagy_nav_next_html pagy, link
      }</nav>)
    end

    private

      def pagy_nav_prev_html(pagy, link)
        if (p_prev = pagy.prev)
          %(<span class="page prev">#{link.call p_prev, pagy_t('pagy.nav.prev'), 'aria-label="previous"'}</span> )
        else
          %(<span class="page prev disabled">#{pagy_t 'pagy.nav.prev'}</span> )
        end
      end

      def pagy_nav_next_html(pagy, link)
        if (p_next = pagy.next)
          %(<span class="page next">#{link.call p_next, pagy_t('pagy.nav.next'), 'aria-label="next"'}</span>)
        else
          %(<span class="page next disabled">#{pagy_t 'pagy.nav.next'}</span>)
        end
      end

  end
end
