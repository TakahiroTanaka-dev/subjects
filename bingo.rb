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
  def stage1
    result = nil

    line = (gets).chop

    # 受け取った文字が半角数字1から3桁で有るかをチェック
    # trueなら入力された数字が3-1000で有るかチェック
    if line =~ /\A(\d{1,3})\z/ and (i = $1.to_i).between?(3,1000)

      result = i
    end

    result
  end

  # ビンゴカードの単語を受け取るメソッド
  # 返り値：受け取った単語をまとめたarray
  def stage2
    result = []

    # Sサイズ分回す
    @line1.times do

      s = (gets).chop

      # 受け取った文字が半角英数字また、単語が複数の場合は半角スペースで区切られているかをチェック
      # trueなら文字数が100文字以内かチェック
      if s =~ /\A[0-9a-z]+(\s+[0-9a-z]+)*?\z/i and s.length <= 100

        # 半角スペースを区切りに分割してarrayする
        s = s.split(/\s+/)

        # 単語の数がSサイズと同じかチェック
        if s.size == @line1          
          result << s
        end
      end
    end

    result
  end

  # 選ばれた単語の数、Nを受け取るメソッド
  # 返り値：正常なら1から2000の半角数字、異常ならnil
  def stage3
    result = nil

    
    line = (gets).chop

    # 受け取った文字が半角数字1から3桁で有るかをチェック
    # trueなら入力された数字が1-2000で有るかチェック
    if line =~ /\A(\d{1,3})\z/ and (i = $1.to_i).between?(1,2000)

      result = i
    end

    result
  end

  # 選ばれた単語、N行を受け取るメソッド
  def stage4
    result = []

    # N行分回す
    @line3.times do

      s = (gets).chop

      # 受け取った文字が半角英数字かをチェック
      # trueなら文字数が100文字以内かチェック
      if s =~ /\A[0-9a-z]+\z/i and s.length <= 100

        result << s
      end
    end

    result
  end

  def make_numbers
    @line2.each_with_index do |col,idx|
      col.each_with_index do |v,i|
        if @line4.index(v)
          @numbers << idx.succ + (i * @line1)
        end
      end
    end
  end

  def make_map
    base = (1..@line1).to_a
    tmap = []
    tmap << base.map.with_index{|a,j| 1 + (j*@line1.succ)}
    tmap << base.map.with_index{|a,j| @line1 + (j*(@line1-1))}

    vmap = []
    (1..@line1).each do |i|
      vmap << base.map.with_index{|a,j| i + (j*@line1)}
    end

    hmap = []
    (1..@line1).each do |i|
      hmap << base.map.with_index{|a,j| a + ((i-1)*@line1)}
    end

    @maps = tmap + vmap + hmap
  end

  def make
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