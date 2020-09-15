using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            // Sを読み込む。
            int S = int.Parse(Console.ReadLine());

            // S*Sの配列を作る。
            string[,] squares = new string[S, S];

            // S行分ループする。
            for (int i = 0; i < S; i++)
            {
                // その行に埋める内容を読み込む。
                var wordsInLine = Console.ReadLine().Split(' ');

                // S列分ループする。
                for (int j = 0; j < S; j++)
                {
                    // そのマスに埋める。
                    squares[i, j] = wordsInLine[j];
                }
            }

            // Nを読み込む。
            int N = int.Parse(Console.ReadLine());

            // S*Sの配列を作り、全てfalseな状態とする。
            bool[,] opens = new bool[S, S];

            // N個の当たり単語をループし、該当するマスがあれば開ける。
            for (int i = 0; i < N; i++)
            {
                // i個目の当たり単語を読み込む。
                var word = Console.ReadLine();

                // j行目をループする。
                for (int j = 0; j < S; j++)
                {
                    // k列目をループする。
                    for (int k = 0; k < S; k++)
                    {
                        // j行k列目のマスに埋めておいた単語が当たりのwordと一致するなら
                        if (squares[j, k] == word)
                        {
                            // そのマスを開いている状態にする。
                            opens[j, k] = true;

                            // このwordについて、これ以上調べる必要はない。
                            goto NEXT_I;
                        }
                    }
                }
            NEXT_I:;
            }

            // S行分ループし、横方向のビンゴ成立を確認する。
            for (int i = 0; i < S; i++)
            {
                // ひとまずビンゴが成立している扱いにする。
                bool win = true;

                // S列分ループする。
                for (int j = 0; j < S; j++)
                {
                    // i行j列が開いていないなら
                    if (!opens[i, j])
                    {
                        // この行はビンゴではない。
                        win = false;

                        // i行目はこれ以上調べる必要がない。
                        break;
                    }
                }

                // 開いていないマスが見つからなかったということは
                if (win)
                {
                    // この行でビンゴが成立している。
                    Console.WriteLine("yes");

                    // これ以上調べる必要がない。
                    return;
                }
            }

            // S列分ループし、縦方向のビンゴ成立を確認する。
            for (int i = 0; i < S; i++)
            {
                // ひとまずビンゴが成立している扱いにする。
                bool win = true;

                // S行分ループする。
                for (int j = 0; j < S; j++)
                {
                    // j行i列が開いていないなら
                    if (!opens[j, i])
                    {
                        // この行はビンゴではない。
                        win = false;

                        // i行目はこれ以上調べる必要がない。
                        break;
                    }
                }

                // 開いていないマスが見つからなかったということは
                if (win)
                {
                    // この列でビンゴが成立している。
                    Console.WriteLine("yes");

                    // これ以上調べる必要がない。
                    return;
                }
            }

            // ひとまずビンゴが成立している扱いにする。
            bool winDown = true;

            // S行分ループし、左上から右下方向のビンゴ成立を確認する。
            for (int i = 0; i < S; i++)
            {
                // i行i列が開いていないなら
                if (!opens[i, i])
                {
                    // この行はビンゴではない。
                    winDown = false;

                    // これ以上調べる必要がない。
                    break;
                }
            }

            // 開いていないマスが見つからなかったということは
            if (winDown)
            {
                // ビンゴが成立している。
                Console.WriteLine("yes");

                // これ以上調べる必要がない。
                return;
            }

            // ひとまずビンゴが成立している扱いにする。
            bool winUp = true;

            // S行分ループし、左下から右上方向のビンゴ成立を確認する。
            for (int i = 0; i < S; i++)
            {
                // i行i列が開いていないなら
                if (!opens[i, S - i - 1])
                {
                    // この行はビンゴではない。
                    winUp = false;

                    // これ以上調べる必要がない。
                    break;
                }
            }

            // 開いていないマスが見つからなかったということは
            if (winUp)
            {
                // ビンゴが成立している。
                Console.WriteLine("yes");

                // これ以上調べる必要がない。
                return;
            }

            // ビンゴが成立していなかった。
            Console.WriteLine("no");
        }
    }
}