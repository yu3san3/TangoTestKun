# 単語テストくん

#### 単語テストを行うためのシンプルなiOSアプリです。

## アプリ概要
#### コンセプト
- どこでも簡単に単語練習や単語テストを行える

ただ単に「問題」と「答え」を表示するだけでなく、

- 問題の形式を「日→英」と「英→日」から選べる
- 問題の表示順をシャッフルできる
- 答え合わせボタンを押せば、すぐに答え合わせに移ることができる

などの機能があり、きちんと定着しているか、繰り返し問題を解いて確認することができます。

また、***紙に書いて***解きやすいように、リスト形式で単語を表示するようにした点にこだわりました。

## 画面イメージ
<img src="https://user-images.githubusercontent.com/125545184/220172154-a39f55a9-f227-4137-aca1-8cbdd3057bf6.png" width="240px">
<img src="https://user-images.githubusercontent.com/125545184/220172664-9d027579-d5dd-4349-8e6a-6bf215a7b3f3.png" width="240px">
<img src="https://user-images.githubusercontent.com/125545184/220172793-a4ebca76-a09a-4634-bee2-a2ef23d1e46c.png" width="240px">

## 開発の背景
プログラミングを行うにあたって、英単語を覚えたいと思いました。

ただ、AppStoreにあるものは、

- 単語データを一覧で表示できない
- 単語データの入力に手間がかかる

など、自分の求めているものとは異なりました。

そこで、アプリを自分で作ってみることにしました。

### 開発期間
- 約1日

### 使用技術

- Swift
- SwiftUI

## 今後の展望
- 単語ファイルの作成や簡単な編集を、アプリ内で行えるようにしたいです。
- 現状では、紙に答えを書かずにiPhoneのみでテストを行う場合、問題の答えをを一つづつ確認できません。  
そのため、それぞれの単語をタップしたら、***その単語のみ***答えを見られるような機能があると良いと感じました。
- Apple Watch版のAppも作って、「どこでも簡単に」の幅を広げたいです。

## 機能一覧
- 単語データの読み込み
- 単語データの日本語/英語のみ表示
- 問題の表示順をシャッフル
- 答え合わせ

## 単語データの形式
- プレーンのテキストファイル(`.txt`)を用いる。
- `=`を挟んで左側に日本語、右側に英語を書く。
- 改行をしてから次の単語データを書く。

### データ例.txt

```
りんご=apple  
ベッド=bed  
猫=cat  
犬=dog  
食べる=eat  
食べもの=food  
```

## 使用方法
1. 単語データを用意する。
2. 右上のファイルアイコンをタップして、単語データを選択する。
3. タブを選択して、問題形式(日→英、英→日)を決める。
4. (お好みで)シャッフルアイコンをタップして、問題の表示順を変える。
5. 紙に書いて単語練習をしたり、テストを行ったりする。
6. ペンアイコンをタップして答えを表示し、答え合わせをする。


