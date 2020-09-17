class Bingo

  private
  def initialize
    @line1 = nil
    @line2 = nil
    @line3 = nil
    @line4 = nil
    @numbers = []
    @maps = []
    @bingo_lines = []
  end

  def error(e)
    case e
    when :stage1
      STDERR.puts "error: stage1."
      exit(1)
    when :stage2
      STDERR.puts "error: stage2."
      exit(2)
    when :stage3
      STDERR.puts "error: stage3."
      exit(3)
    when :stage4
      STDERR.puts "error: stage4."
      exit(4)
    end
  end

  # SxSのサイズを受け取るメソッド
  # 返り値：正常なら3から1000の半角数字、異常ならnil
  # ()-> Integer or nil
  def stage1
    result = nil

    # 標準入力から文字を受け取る
    # 改行コードが入ってくるのでchopで削除
    line = (gets).chop

    # 受け取った文字が半角数字1から3桁で有るかをチェック
    # trueなら入力された数字が3-1000で有るかチェック
    if line =~ /\A(\d{1,3})\z/ and (i = $1.to_i).between?(3,1000)

      # 返り値に受け取った数字を代入
      result = i
    end

    result
  end

  # ビンゴカードの単語を受け取るメソッド
  # 返り値：受け取った単語をまとめたarray
  # ()-> Array
  def stage2
    result = []

    # Sサイズ分回す
    @line1.times do

      # 標準入力から文字を受け取る
      # 改行コードが入ってくるのでchopで削除
      s = (gets).chop

      # 受け取った文字が半角英数字また、単語が複数の場合は半角スペースで区切られているかをチェック
      # trueなら文字数が100文字以内かチェック
      if s =~ /\A[0-9a-z]+(\s+[0-9a-z]+)*?\z/i and s.length <= 100

        # 半角スペースを区切りに分割してarray
        s = s.split(/\s+/)

        # 単語の数がSサイズと同じかチェック
        if s.size == @line1
          # 返り値のarrayに追加
          result << s
        end
      end
    end

    result
  end

  # 選ばれた単語の数、Nを受け取るメソッド
  # 返り値：正常なら1から2000の半角数字、異常ならnil
  # ()-> Integer or nil
  def stage3
    result = nil

    # 標準入力から文字を受け取る
    # 改行コードが入ってくるのでchopで削除
    line = (gets).chop

    # 受け取った文字が半角数字1から3桁で有るかをチェック
    # trueなら入力された数字が1-2000で有るかチェック
    if line =~ /\A(\d{1,3})\z/ and (i = $1.to_i).between?(1,2000)

      # 返り値に受け取った数字を代入
      result = i
    end

    result
  end

  # 選ばれた単語、N行を受け取るメソッド
  # 返り値：受け取った単語をまとめたarray
  # ()-> Array
  def stage4
    result = []

    # N行分回します
    @line3.times do

      # 標準入力から文字を受け取る
      # 改行コードが入ってくるのでchopで削除
      s = (gets).chop

      # 受け取った文字が半角英数字かをチェック
      # trueなら文字数が100文字以内かチェック
      if s =~ /\A[0-9a-z]+\z/i and s.length <= 100

        # 返り値のarrayに追加
        result << s
      end
    end

    result
  end

  # ヒットした単語のポジションを@numbersに保存
  # 返り値：ヒットした単語の配列
  # ()-> Array
  def make_numbers

    # ビンゴカードの行と配列のインデックス
    @line2.each_with_index do |col,idx|

      # 行の単語と配列のインデックス
      col.each_with_index do |v,i|

        # 選ばれた単語にビンゴカードの単語が含まれているかチェック
        if @line4.index(v)

          # ヒットした盤面のナンバーを追加
          @numbers << idx.succ + (i * @line1)
        end
      end
    end

    # ヒットした単語の配列
    @numbers
  end

  # ビンゴになる盤面のポジションマップを作成
  # ※1からスタートしNxNで終了する盤面のポジション
  # 返り値：ポジションマップの配列
  # ()-> Array
  def make_map

    # ベースになる横一行のポジション配列
    # 本来1つの配列に代入すれば良いですがわかりやすくするため分割
    # 下記コメントは3x3の場合を記載
    # ビンゴカードのポジションマップ
    # [1,2,3]
    # [4,5,6]
    # [7,8,9]
    
    # 3x3の場合[1,2,3]
    base = (1..@line1).to_a

    # 斜めラインのポジションマップ
    xmap = []

    # 左上・右下への斜めライン
    # baseを元にポジションを計算
    # 1行目1からスタートして行毎に右に1マス進むイメージ
    # [1,5,9]
    xmap << base.map.with_index{|a,j| 1 + (j*@line1.succ)}

    # 右上・左下への斜めライン
    # baseを元にポジションを計算
    # 1行目右端からスタートして行毎に左に1マス戻るイメージ
    # [3,5,7]
    xmap << base.map.with_index{|a,j| @line1 + (j*(@line1-1))}

    # 縦ラインのポジションマップ
    vmap = []

    # 上・下への縦ライン
    (1..@line1).each do |i|

      # baseを元にポジションを計算
      # [1,4,7],[2,5,8],[3,6,9]
      vmap << base.map.with_index{|a,j| i + (j*@line1)}
    end

    # 横ラインのポジションマップ
    hmap = []

    # 左・右への横ライン
    (1..@line1).each do |i|

      # baseを元にポジションを計算
      # [1,2,3],[4,5,6],[7,8,9]
      hmap << base.map.with_index{|a,j| a + ((i-1)*@line1)}
    end

    # 全ての配列をつなげて保存
    @maps = xmap + vmap + hmap
  end

  # ビンゴ結果生成
  def make

    # 下記2メソッドはインスタンス変数に保存することが目的なので返り値は無視
    make_numbers()
    make_map()

  end

  public

  def bingo?
    result = nil
    make()

    @maps.each do |map|
      numbers = []
      map.each do |pos|
        if @numbers.index(pos)
          numbers << pos
        end
      end

      if numbers.size == @line1
        @bingo_lines << numbers
      end
    end

    case @bingo_lines.size
    when 1
      result = "1 line BINGO!"
    when 0
      result = false
    else
      result = sprintf("%d lines BINGO!", @bingo_lines.size)
    end

    result
  end

  def party
    unless @line1 = stage1()
      error(:stage1)
    end

    if (@line2 = stage2()).size != @line1
      error(:stage2)
    end

    unless @line3 = stage3()
      error(:stage3)
    end

    if (@line4 = stage4()).size != @line3
      error(:stage4)
    end
  end
end

begin
  while true do

    bingo = Bingo::new
    bingo.party()

    if r = bingo.bingo?
      puts "yes"
    else
      puts "no"
    end

    puts "------------------"
    puts "to continue? (Y/n)"
    puts "------------------"
    if (gets).chop =~ /\A(\s*[n])/i
      break
    end

  end
rescue Interrupt
  puts ""
end

puts "^^^^^^^^^^^^^^^^^^"
puts "Bye!".center(18)
puts "^^^^^^^^^^^^^^^^^^"

exit(0)

