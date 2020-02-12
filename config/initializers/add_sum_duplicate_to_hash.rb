class Hash
  def merge_and_sum(hash_to_merge)
    self.merge!(hash_to_merge){ |_, a_value, b_value| a_value + b_value }
  end
end
