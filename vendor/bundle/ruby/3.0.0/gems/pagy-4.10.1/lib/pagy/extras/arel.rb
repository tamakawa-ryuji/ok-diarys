# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/arel
# frozen_string_literal: true

class Pagy
  module Backend
    private

    def pagy_arel(collection, vars={})
      pagy = Pagy.new(pagy_arel_get_vars(collection, vars))
      [ pagy, pagy_get_items(collection, pagy) ]
    end

    def pagy_arel_get_vars(collection, vars)
      pagy_set_items_from_params(vars) if defined?(UseItemsExtra)
      vars[:count] ||= pagy_arel_count(collection)
      vars[:page]  ||= params[ vars[:page_param] || VARS[:page_param] ]
      vars
    end

    def pagy_arel_count(collection)
      if collection.group_values.empty?
        # COUNT(*)
        collection.count(:all)
      else
        # COUNT(*) OVER ()
        sql = Arel.star.count.over(Arel::Nodes::Grouping.new([]))
        collection.unscope(:order).limit(1).pluck(sql).first.to_i
      end
    end

  end
end
