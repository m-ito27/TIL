## deviseのstretchesで、ハッシュ関数を繰り返しかける回数を決めている

デフォルトは2023年7月10日時点で12
https://github.com/heartcombo/devise/blob/ec0674523e7909579a5a008f16fb9fe0c3a71712/lib/generators/templates/devise.rb#L126

テスト環境は1にすることでテストを高速化できる（デフォルトは1に既になっている）
