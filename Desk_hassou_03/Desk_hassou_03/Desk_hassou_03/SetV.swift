//
//  SetV.swift
//  randam_hint_v-1.00
//
//  Created by kakegawa kouichi on 2019/04/29.
//  Copyright © 2019 kakegawa kouichi. All rights reserved.
//

import Foundation
import RealmSwift
import Cocoa

class Point_Store {
    var x = -999.0
    var y = -999.0
}
class CustomNSButton: NSButton {
    var st = ""
    var area_loc = -999
    var index = -999
}
class CustomNSTextField: NSTextField {
    var loc_x = -999.0
    var loc_y = -999.0
    var area_loc = -999
    var index = -999
}
enum Direction {
    case yoko
    case tate
    case none
}
class Param{
    var st = ""
    var x = 0
    var y = 0
    var width = 0
    var height = 0
    var fontSize = 0
    var backColor = NSColor.white
    var serchSt = ""
    var tag = 0
    init(x_:Int,y_:Int,width_:Int,height_:Int,fontSize_:Int,tag_:Int) {
        self.x = x_
        self.y = y_
        self.width = width_
        self.height = height_
        self.fontSize = fontSize_
        self.tag = tag_
    }
    init(st_ :String,x_:Int,y_:Int,width_:Int,height_:Int,fontSize_:Int) {
        self.st = st_
        self.x = x_
        self.y = y_
        self.width = width_
        self.height = height_
        self.fontSize = fontSize_
    }
    init(st_ :String,x_:Int,y_:Int,width_:Int,height_:Int,fontSize_:Int,backColor_:NSColor) {
        self.st = st_
        self.x = x_
        self.y = y_
        self.width = width_
        self.height = height_
        self.fontSize = fontSize_
        self.backColor = backColor_
    }
}

class group_set_color{
    var group = ""
    var backColor:NSColor = NSColor.clear
}

class Proposal_Seed: Object{
    @objc dynamic var seed = ""
    @objc dynamic var question = ""
    @objc dynamic var answer = ""
}

class Index_Collect: Object{
    @objc dynamic var theme = ""
    @objc dynamic var index = ""
}

class Process_s_DB_2: Object{
    @objc dynamic var theme = ""
    @objc dynamic var index = -999
    @objc dynamic var content = ""
    @objc dynamic var comment = ""
}


class Randam_Area_S_DB: Object{
    @objc dynamic var start_theme = ""
    @objc dynamic var theme = ""
    @objc dynamic var disp_count = -999
    @objc dynamic var idea = ""
}
class Random_Loc_Idea: Object{
    @objc dynamic var theme = ""
    @objc dynamic var idea = ""
    @objc dynamic var x = -999.0
    @objc dynamic var y = -999.0
    @objc dynamic var disp_num = -999
    // 追加したテキストボックスから文字列を取得するための変数
    @objc dynamic var tag = -999
}
class Hierarchy_Theme_Db_v5: Object{
    @objc dynamic var start_theme = ""
    @objc dynamic var parent_theme = ""
    @objc dynamic var parent_x = -999
    @objc dynamic var parent_y = -999
    @objc dynamic var self_theme = ""
    @objc dynamic var self_x = -999
    @objc dynamic var self_y = -999
    // これは、全体を取得してから再取得。
    @objc dynamic var self_point_x = -999
    @objc dynamic var last_flag : Bool = false
    // これは、使うかまだ、分からないけど。
    // last_flag trueの場合に順番を保持。
    @objc dynamic var last_index = -999
    @objc dynamic var child_idea_num = -999
}

class Group_Divide_Db: Object{
    @objc dynamic var theme = ""
    @objc dynamic var idea = ""
    @objc dynamic var gourp_label = ""
    @objc dynamic var comment = ""
}

// これ、最初からテーマを持たせるべきだった。。。
class Group_Label_Db: Object{
    @objc dynamic var gourp_label = ""
}

// でも元のを変更すると壊れる確率が高いので、やらない。
class Group_Label_Db_ver3: Object{
    @objc dynamic var theme = ""
    @objc dynamic var gourp_label = ""
}

class Rnadom_Conb_Db: Object{
    // hint_1には、テーマを入れようかと思う。
    // DBを作り直すのが面倒なので、このままいこうかなと思う。
    @objc dynamic var hint_1 = ""
    @objc dynamic var hint_2 = ""
    @objc dynamic var hint_3 = ""
    @objc dynamic var think = ""
}

class Hint_Db: Object{
    @objc dynamic var theme = the_theme
    @objc dynamic var content = ""
}

// これGroup_Divide_Dbと一緒だからいらないね。。。
// コメントは、その画面ではつけないけども。
// と思ったが、色々ややこしくなりそうなので、DBを分ける。
class Grouped_Stock: Object{
    @objc dynamic var theme = ""
    @objc dynamic var group = ""
    @objc dynamic var idea = ""
}
class Grouped_Stock_Num: Object{
    @objc dynamic var theme = ""
    @objc dynamic var group = ""
    @objc dynamic var idea = ""
    // 横から何番目に表示されるかを記録する
    @objc dynamic var num = -999
}

class Idea_Stock: Object{
    @objc dynamic var theme = ""
    @objc dynamic var hint = ""
    @objc dynamic var idea = ""
}

class Nine_x_Nine_Stock: Object{
    @objc dynamic var y0_x0 = ""
    @objc dynamic var y0_x1 = ""
    @objc dynamic var y0_x2 = ""
    @objc dynamic var y0_x3 = ""
    @objc dynamic var y0_x4 = ""
    @objc dynamic var y0_x5 = ""
    @objc dynamic var y0_x6 = ""
    @objc dynamic var y0_x7 = ""
    @objc dynamic var y0_x8 = ""

    @objc dynamic var y1_x0 = ""
    @objc dynamic var y1_x1 = ""
    @objc dynamic var y1_x2 = ""
    @objc dynamic var y1_x3 = ""
    @objc dynamic var y1_x4 = ""
    @objc dynamic var y1_x5 = ""
    @objc dynamic var y1_x6 = ""
    @objc dynamic var y1_x7 = ""
    @objc dynamic var y1_x8 = ""

    @objc dynamic var y2_x0 = ""
    @objc dynamic var y2_x1 = ""
    @objc dynamic var y2_x2 = ""
    @objc dynamic var y2_x3 = ""
    @objc dynamic var y2_x4 = ""
    @objc dynamic var y2_x5 = ""
    @objc dynamic var y2_x6 = ""
    @objc dynamic var y2_x7 = ""
    @objc dynamic var y2_x8 = ""

    @objc dynamic var y3_x0 = ""
    @objc dynamic var y3_x1 = ""
    @objc dynamic var y3_x2 = ""
    @objc dynamic var y3_x3 = ""
    @objc dynamic var y3_x4 = ""
    @objc dynamic var y3_x5 = ""
    @objc dynamic var y3_x6 = ""
    @objc dynamic var y3_x7 = ""
    @objc dynamic var y3_x8 = ""

    @objc dynamic var y4_x0 = ""
    @objc dynamic var y4_x1 = ""
    @objc dynamic var y4_x2 = ""
    @objc dynamic var y4_x3 = ""
    @objc dynamic var y4_x4 = ""
    @objc dynamic var y4_x5 = ""
    @objc dynamic var y4_x6 = ""
    @objc dynamic var y4_x7 = ""
    @objc dynamic var y4_x8 = ""

    @objc dynamic var y5_x0 = ""
    @objc dynamic var y5_x1 = ""
    @objc dynamic var y5_x2 = ""
    @objc dynamic var y5_x3 = ""
    @objc dynamic var y5_x4 = ""
    @objc dynamic var y5_x5 = ""
    @objc dynamic var y5_x6 = ""
    @objc dynamic var y5_x7 = ""
    @objc dynamic var y5_x8 = ""

    @objc dynamic var y6_x0 = ""
    @objc dynamic var y6_x1 = ""
    @objc dynamic var y6_x2 = ""
    @objc dynamic var y6_x3 = ""
    @objc dynamic var y6_x4 = ""
    @objc dynamic var y6_x5 = ""
    @objc dynamic var y6_x6 = ""
    @objc dynamic var y6_x7 = ""
    @objc dynamic var y6_x8 = ""

    @objc dynamic var y7_x0 = ""
    @objc dynamic var y7_x1 = ""
    @objc dynamic var y7_x2 = ""
    @objc dynamic var y7_x3 = ""
    @objc dynamic var y7_x4 = ""
    @objc dynamic var y7_x5 = ""
    @objc dynamic var y7_x6 = ""
    @objc dynamic var y7_x7 = ""
    @objc dynamic var y7_x8 = ""

    @objc dynamic var y8_x0 = ""
    @objc dynamic var y8_x1 = ""
    @objc dynamic var y8_x2 = ""
    @objc dynamic var y8_x3 = ""
    @objc dynamic var y8_x4 = ""
    @objc dynamic var y8_x5 = ""
    @objc dynamic var y8_x6 = ""
    @objc dynamic var y8_x7 = ""
    @objc dynamic var y8_x8 = ""
}

//class Theme_Stock: Object{
//    @objc dynamic var theme = ""
//}

// DB挿入手順
// ①the_themeを書き換える
// ②新しい配列を作る
// ③new_insert_arrayに②の配列を格納する
// ④メイン画面にボタンを配置する

//let the_theme = "ブレーンステアリング_1"
//let new_insert_array = braneStearing_1
//let the_theme = "マイテーマ_1"
//let new_insert_array = myThemes_1
//let the_theme = "オズボーン_1"
//let new_insert_array = osborneChecklist_1
let the_theme = "トゥリーズ_1"
let new_insert_array = triz_1

let simple_hint_1_theme = "シンプル_1"
let simple_hint_1 = [
    "➕",
    "➖",
    "✖️",
    "➗",
    "逆",
    "分岐"]
let triz_1_theme = "トリズ_1"
let triz_1 = [
    "分割",
    "分離",
    "局所性",
    "非対称",
    "組み合わせ",
    "汎用性",
    "入れ子",
    "つりあい",
    "予備対応",
    "先取り",
    "事前保護",
    "等位性",
    "逆転",
    "曲面",
    "ダイナミック",
    "アバウト",
    "多次元転換",
    "機能的振動",
    "周期的作用",
    "連続性",
    "超高速作業",
    "害益転換",
    "フィードバック",
    "仲介",
    "セルフサービス",
    "模造的代替",
    "安価短寿命",
    "機械代替",
    "液体利用",
    "薄膜利用",
    "多孔質利用",
    "変色",
    "均質性",
    "放棄再生",
    "状態変移",
    "位相転換",
    "熱膨張",
    "高酸化利用",
    "不活性利用",
    "複合材料"
]

let braneStearing_1_theme = "ブレーンステアリング_1"
let braneStearing_1 = [
"顧客にとって一番煩わしい（ただし避けられる）問題は何か？",
"現在の製品が最も適さないのはどんな利用者か、またはどんな場合か？",
"業界の今の顧客基盤に匹敵する規模の潜在顧客層なのに、ある特定の（ただし対処可能な）理由で当社の製品やサービスを購入していないのはどんな人たちか？",
"当社の製品やサービスを驚くほど大量に利用するのはどんな人か？また、その理由は？","業界内で敬遠されているのはどんな顧客か？また、その理由は？",
"当社の製品やサービスを全く想定外の方法で使っているのはどんな人か？",
"もし顧客や製品の使われ方、流通事情について完璧な情報があったら仕事のしかたはどう変わるか？",
"もし顧客にだまされることはないと信じたら（あるいは、ごく少数にだまされても気にしなければ）、仕事をどう変えるか？",
"今の「規則」で、私たち（またはほかの誰か）が現在活用している以上に融通性があるのはどの部分か？",
"私たちが従っている「規則」で、その実際の意味を長いこと再検証しないまま容認しているものはないか？",
"当社の生産・業務プロセスの基盤となるテクノロジーで、最近の製品変更や製造・流通システム再編の後、最も大きくかわったのはどれか？"
]
let myThemes_1_theme = "マイテーマ_1"
public let myThemes_1  = [
"協創ITツールを開発・普及するには？",
"より努力をしやすい、努力の成果が発揮されやすい社会を構築するには？",
"イノベーター養成機関を設立するには？",
"書籍のアプリ化の市場を開拓するには？",
"コンサルティングサービスの一般化、多様化、低価格化、マッチングの簡易化を推進するには？",
"サッカーの新しいトレーニング体系を構築するには？",
"発想法のyoutuberとして活躍するには？",
"発想法のyoutuberとしてアイデア出しをしたいテーマは何か？",
"発想法のyoutuberとして使いたいツールは何か？"
]

let osborneChecklist_1_theme = "オズボーン_1"
public let osborneChecklist_1  = [
"転用・新しい使い方はないか？"
,"転用・他の分野での使い道はないか？"
,"応用・他のアイデアから応用できない"
,"応用・似た商品のアイデアを使えないか？"
,"変更・見た目を変えられないか？"
,"変更・意味を変えられないか？"
,"拡大・大きくできないか？"
,"拡大・地域を広げられないか？"
,"縮小・小さくできないか？"
,"縮小・機能を減らせないか？"
,"代用・他の物で代用できないか？"
,"代用・他の素材で代用できないか？"
,"置換・配置を入れ替えられないか？"
,"置換・順序を入れ替えられないか？"
,"逆転・順番を逆にできないか？"
,"逆転・考え方を逆にできないか？"
,"結合・何かと組み合わせられないか？"
,"結合・真逆のものと組み合わせられないか？"
]

let not_related_hint_1_theme = "関係ない_1"
public let not_related_hint_1  = ["ベンチ","縦坑","サッカー","結び目","鉤","レジ係","ひしゃく","女","封筒","刑務所","橋","種","磁石","トースト","昆虫","鋤","ほうき","バッグ","ロープ","雑草","スパゲッティ","スープ","薔薇","マットレス","ラジオ","鎖","滑車","青あざ","ディスコ","洗髪財","蠅","日没","地主","魚雷","つま先","トイレ","画鋲","ビール","化石","門","クロゼット","ネクタイ","靴","バター","時計","癌","目","鉤","シャツ","流し台","卵","ナッツ","発疹","鉋","ポット","ドア","ポケット","遠近両用メガネ","肉","枝","車","錠剤","結婚指輪","窓","パイプ","テレビ","カップ","鳥","道","チケット","ワイン","屋根","ゴム","ゼリー","傘","刀","動物園","道具","税金","湖","モーター","美術館","ハンマー","豚","ヴァイオリン","酸","本","審判","怪物","絵画","円","鍬","キャンディ","切手","灰皿","空","犬","砂","針","ネズミ","樋","カブトムシ","ライター","海","野原","メニュー","敷物","中華鍋","コンピュータ","太陽","ヒップ","コショウ","銃","インデックス","煙","ゴンドラ","ペンキ","夏","ネズミ","バルブ","ココナッツ","男","氷","ポスター","三角形","辞書","スーツケース","金銭","電話","接着剤","埃","通路","サーモスタット","ファイル","魚","雑誌","みぞれ","水","聖書","ミルク","チューブ","ロビー","ランプ","ねじ回し","鐘の音","ビン","太鼓","馬","蛸","雲","図書館","ビデオデッキ","ノート","ネオン","霧","潮流","煙","火山","大学","ステレオ","肉の缶詰","粘土","ディナー","てこ台","インク","香水","キャンプファイアー","日時計","酒","グルメ","ラベル","バーベキューコンロ","溝","ガム","花火","リス","パイロット","ロースト","実験室","缶","カミソリ","チーズ","トマト","口ひげ","口紅","熱","サンドペーパー","煙突","紅茶","炎","舌","オルガン","キャビア","リムジン","くさび","金串","点眼器","果物","破砕","大臼歯","有害廃棄物","俳優","ハム","スイカ","ゲットー","駐車場","インド人","少年聖歌隊","コーヒー","ホームレス","高速道路","クリスマス","女性ホームレス","肺","ヘビ","ペット","灰","女王","ランジェリー","政治家","幽霊","スピーチ","狐","マーモット","芸術家","ゼリー","ウズラ","アスリート","数学","ロブスター","消しゴム","胸郭","嵐","泡","ハンドボール","群れ","戦争","悪魔","ビキニ","カラシニコフ銃","フルート","ブランチ","バルーン","峡谷","歌","トロフィー","ゴミ箱","ドーナッツ","竿","ヨット","ソース","カード","議会","十二宮","腕時計","ママ","憲法","鏡","にきび","ボタン","矢","七面鳥","旗","ピーナッツ","ハンカチ","ゴボウ","水晶","防護服","はちみつ","打ち寄せる波","ヘルメット","ダンス","鍵","汚泥","エビ","フィルム","風呂","冷蔵庫","サボテン","軍隊","走路","イヌイット","ドラゴン","カウボーイ","爆発物","雨林","ミサ","大根","フラミンゴ","桶","亀","居酒屋","ダイアモンド","島","失われた環","レンガ","警察","支配者","海草","蝶","ラクダ","日の出","静脈","ホワイトハウス","遊牧民","ビーフシチュー","立方体","葉","プラスチック","トラック","ケチャップ","溶岩","地下道","泥","X線","列車","ヒンドゥー教徒","僧","ミミズ","オリーブ","ドアのベル","フライパン","石けん","ワゴン","マッシュルーム","サメ","惑星","地図","大理石","キャンドル","さいころ","拡大鏡","ガソリン","タマネギ","オペラ","クーポン","結び目","バンジョー","電気のコンセント","針金","音楽","ガレージ","カメレオン","泡","ポンプ","アリクイ","鼻","ドック","休憩","ラム酒","いぼ","鼻血","アンパイア","テント","アポロ13号","岩","雨","屋根裏部屋","葬式","しおり","トップ","ホッケー","暖炉","鮭","耳","タクシー","ギア","懐中電灯","カーソル","ウナギ","デリカッテセン","水面下","豆","シマウマ","カーペット","墓","タイヤ","ロケット","ナップサック","おむつ","点火プラグ","エレベーター","ウィンドサーファー","引きだし","艀","サーカス","突起","バット","階段","シャンペン","金","靴下","くず","蟻","マイク","芝刈り機","枝","ピラミッド","かすがい","文鎮","穴","はしご","ジャガー","ピエロ","コピー機","ドーム","スパナ","フライパン","ブックエンド","バス","蛍","縁石","机","礼拝堂","浮浪者","ライフル銃","おもちゃ","スズメバチ","指紋","バイブレーター","雷","ソフトウェア","クリップ","カフスボタン","髪","月","ゲリラ","イアリング","ムカデ","スター","心電図","ベルト","苔","ヨードチンキ","シャワー","タイル","池","ジャム","演壇","生物学","コンパス","鯉","ピアノ","夢","胃","銀","スコッチ","牛","入れ墨","展覧会","地平線","鉛筆","ブラシ","顕微鏡","帽子","包帯","断熱材","ホロコースト","小さな入り江","ステーキ","リンパ腺","爪","ジェット","カレンダー","足","税金","雪","ひな型","腸","ピストン","ソーダ","計算機","小麦","仔羊","聖職者","赤信号","ケーキ","パン","チェス","バッファロー","ランドリー","子供","医者","告白","フェンス","紙","シチュー","凧","道具箱","鷲","塩","ルーレット","歯ブラシ","ソーダ","ウェイター","金輪","箸","衣裳","口","宇宙船","虹","保険","ガチョウ","射手","バスローブ","天国","地平線","判事","アパート","ペナント","サンドイッチ","ハンター","良心","脳","パラシュート","スニーカー","バレエ","チョーク","雑魚","ウォッカ","チョッキ","スプーン","プリン","椅子","散弾銃","ビリヤードテーブル","社会","絶望","蟹","スイング","パセリ","排水溝","土","広口ビン","試験","メイド","宝くじ","スケート","類人猿","ジッパー","クリーム","ブレスレット","創世記","櫛","熊手","カーテン","歩道","求人広告","皮膚","衛星","表皮","絵","兵士","ワックス","ボート","罪","火","ディスク","馬","風","火事","ペンダント","ヘリコプター","影","ジープ","ネックレス","ゴルフ","コミック","詩","線路","釣り竿","房","ロレックス","フラッシュ","占いクッキー","ローラー","血","メガフォン","米","手","郵便受け","記念碑","小銭","マット","城","摩天楼","櫂","シャンプー","ダム","地図帳","フォルクスワーゲン","心理学","スカイライン","教師","電話帳","サファリ","聖杯","ホイールキャップ","絹","目隠し","イチジク","銀行","カフスボタン","稲妻","シンボル","ボール箱","地震","歯","棒","中国","真空","彫刻","地球","砂糖","スーパーマーケット","花","臨海地","ファン","裁判所","板","干草","マッチ","紐","クジラ","タウンハウス","ハンドル","チップス","キーボード","十字架","ボルト","ティーバック","チョコレート","天使","十字路","蒸気","ヌードル","外套","ドリル","氷山","ボクシンググローブ","メダル","親","円盤","劇場","ボールベアリング","オレンジ","かたつむり","網の輪","噴水","青写真","ブロードウェイ","マスト","錠","たばこ","密林","ジーンズ","爪","森林","リモコン","小屋","テロリスト","神話","丸太小屋","空中","あごひげ","テント","日焼け","骨","食器洗浄機","旅","シロップ","クレヨン","生徒","漂白剤","イーゼル","著名人","輪","親指","石工","地獄","爆弾","コード","洪水","革","バトン","バスケット","宝石","奇跡","空港","やっとこ","ゴキブリ","雪片","オーケストラ","財布","膝","椰子の木","挽き割りトウモロコシ","マジシャン","フライパン","サラダ","サスペンダー","アーチ","セーター","聖歌隊","トウモロコシの茎","蛇口","クルーカット","国会議員","ブラジャー","クローク","バンド","ソーセージ","有機肥料","トラクター","ブロック","霜","トリビア","トランペット","壁紙","胴","RV車","ロウソク立て","スクリーン","ガードル","外皮","円錐形","塔","ピクルス","柱時計","新聞","花瓶","ストーブ","オアシス","温度","キッチン","鳩","大型巡航船","秘書","地下室","ホテル","小川","榴弾砲","虫眼鏡","ホイップ","ステージ","セールスマン","ロゴ","人質","ラリー","庭","糸くず","双眼鏡","ふけ","商人","将軍","ミートボール","聴衆","パイロット","ヒョウタン","肉屋","肋骨","箱","眉毛","テープ","毛皮","ミルクセーキ","ポリエステル","ダイニング・セット","マフィン","柳","章","棺桶","ジュース","手押し車","カーボーイハット","ベッド","薬","棒","カタログ","草原","ビュッフェ","レベル","分","ロッカー","カエル","食堂","帽子","台風","夫","叔母","IRA","教授","唇","バクテリア","にきび","オフィス","シリアル","ビンゴゲーム","ティーンエイジャー","辞典","スイカ","魂","ピザ屋","杖","綿","雑草","手錠","ワークショップ","膝","サウナ","バルコニー","グラフ","パンフレット","紙","組み立て玩具","チーズケーキ","沼","モノポリー","共産主義者","アンプ","パントマイム","スタジオ","チェス","ギャング","炉","カビ","生け垣","ライン","肘","あて布","足場","棚","ベーグル","航空母艦","パター","爆撃機","プルーン","CIA","船首","かつら","牛肉","潜水艦","藪","教科書","ポーカー","蚊","膝頭","脱臭剤","床","珊瑚礁","タグボード","境界線","肉汁","チェリー","ボルシチ","ニュース","納屋","カジノ","枷","ヤマヨモギ","敷き藁","ガラガラヘビ","レインコート","ディスプレイ","イルカ","革命","手袋","アルミニウム","サックス","夜明け","インターネット","シャッター","ヌード","講堂","蒸気機関車","豹","カラシナの種子","ヘッドハンター","電磁波","安全ピン","裁判","タイマー","崖","チーム","シンボル","マッチ棒","サイ","貨物","旅行者","ハーブ","縫い目","ホチキス","脂肪","マシュマロ","レモン","破片","コルク","腫瘍","補聴器","アメリカ合衆国","ウサギ","かかし","ガーター","ソーセージ","区画","高速道路","文法","アヒル","光線","オフィス","そよ風","肥料","言葉","ホタテ貝","英雄","火葬","心理学","はがき","宴会","カートリッジ","カボチャ","恐怖","ネットワーク","わさび","イースター","大根","葉巻","妖精","配管工","ハンバーガー","聖典","グループ","傷跡","写真","装飾品","シャトル","バーの常連","社会福祉","錨","ダンサー","頭皮","病気","旅客機","役人","ワセリン","カリフラワー","ほうれん草","掲示版","卵の殻","メディア","ネズミ","配当","野火","ランタン","予報","プラム","平和部隊","笑い","カルト","病院","水仙","硫黄","格子","小切手","逃亡者","主役","硬貨","タンク","ビニール","ワニ","ニシン","ボードゲーム","峡谷","台本","ロボット工学","ソナー","ブレーキ","コブラ","戦士","国土航空局","ハワイ","接触","エンジニア","いわし","空洞","ガマ","オカルト","タール","キリン","ゆりかご","オリンピック","レバー","インコ","カエデ","かさぶた","埋め立て","大牧場","アルファベット","鱒","盾","豚足","教室","刑事","賃金","吸血鬼","レタス","ハサミ","燃料","排泄物","教皇","英国","休暇","エメラルド","トナカイ","砂丘","日本","蔓","統計学者","だんご","ダイヤル","連合","刷毛","額","ホッケー","望遠鏡"]

