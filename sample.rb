
class String
  def truncate(num, omission: '...')
    omission_count = omission.size

    if size <= num # そのまま表示できる場合
      self
    else # 「...」など表示する場合
      display_str_count = num - omission_count # 表示する文字数
      display_str_count = 0 if display_str_count <= 0 # 表示する文字数がないときは0で固定
      self[...display_str_count] + omission
    end
  end
end

p 'abcde'.truncate(5)
