package cn.geckos.utils
{
public class NameUtil
{
	private static const FAMILY_NAME:String = '王,陈,李,张,刘,杨,黄,吴,林,周,叶,赵,吕,徐,孙,朱,高,马,梁,郭,何,郑,胡,蔡,曾,佘,邓,沈,谢,唐,许,罗,袁,冯,宋,苏,曹,陆,姚,董,于,韩,任,蒋,顾,钟,方,杜,丁,印,潘,姜,谭,邱,宗,金,贾,田,崔,程,余,魏,薛,戴,范,卢,洪,侯,夏,白,贺,钱,庄,邹,汪,史,路,石,彭,龚,秦,廖,黎,施,傅,赖,江,邵,毛,刑,倪,严,阎,常,康,牛,万,陶,孟,葛,尹,雷,盛,樊,齐,褚,柯,龙,曲,郝,关,纪,温,乔,汤,殷,皮,段,蓝,韦,毕,裴,章,颜,阮,俞,翁,孔,凌,武,文,季,熊,安,鲁,祝,房,尤,伍,焦,米,向,骆,莫,童,屈,苗,耿,宫,柴,易,尚,佟,霍,茅,庞,岳,辛,聂,翟,左,单,蒲,包,牟,解,穆,滕,游,谷,卞,费,屠,詹,储,党,鲍,寿,艾,车,卫,付,萧,戚,项,卜,晁,杭,乐,慕,司马,上官,欧阳,夏侯,诸葛,皇甫,尉迟,宗政,公孙,轩辕,令狐,宇文,慕容,司徒,公冶';
	private static const MALE_LAST_NAME:String = '文,少,维,兆,冬,宁,洁,伟,彬,渊,刚,春,志,书,舟,亮,鸣,胡,立,迪,振,明,佳,斐,海,玮,驰,冰,景,建,峰,中,宇,思,苏,弘,仁,桐,冉,诺,东,昌,迅,峻,奕,诚,谦,阳,瑞,恒,生,豪,贤,涵,彦,汉,天,平,翔,邦,宏,翰,震,然,涛,威,杰,智,鸿,帅,松,树,鹏,扬,庭,飞,荣,世,卓,泽,伦,龙,言,俊,波,丰,雄,柏,家,达,宗,烈,君,凯,嘉,裕,学,英,锡,悠,心,正,司,耀,良,浩,仲,逸,锦,国,德,宾,羽,晓,轩,元,叶,洋,秋';
	private static const FEMALE_NAME:String = '若,雨,闲,苑,亦,晓,渝,忆,蕊,秋,馨,雅,恬,欣,汐,藜,芊,静,如,冰,婉,曼,旖,柔,绮,淑,懿,蔚,皓,华,碧,文,芍,芷,楚,秀,奕,熙,筱,梦,彤,琉,斯,心,霖,悠,纯,冷,琦,泪,芸,思,伶,薇,姿,姗,诗,歆,莹,黎,隽,雪,晶,妍,紫,洋,慧,冬,妤,佳,维,辰,茜,蓉,惜,露,艾,琪,安,敏,幽,妮,颜,卿,茹,蕾,悦,希,瑶,娜,婷,藩,丽,蓝,月,伊,婧,舒,洁,晴,璃,潇,逸,昀,嫣,颖,雯,菲,香,寒,芯,苛,鸣,芬,旎,霏,玲,媛,蔼,轩,韵,弥,冉,聪,乐,爱,汶,飞,倩,浅,水,云,薰,清,红,新,楠,茶,智,语,玫,叶,羽,凡,灵,凌,林,琳,萍,波,芳,亚,宁,音,萧,莲,梅,飘,梨,绒,婕,兰,丝,荀,晨,翼,天,晟,圆,松,桃,缘,珊,笛,迪,美,亭,甜,可,瑞,誉';
	private static const ENGLISH_NAME:String = 'A,a,B,b,C,c,D,d,E,e,F,f,G,g,H,h,I,i,J,j,K,k,L,l,M,m,N,n,O,o,P,p,Q,q,R,r,S,s,T,t,U,u,V,v,W,w,X,x,Y,y,Z,z';
	private static const NUMBER_NAME:String = '0,1,2,3,4,5,6,7,8,9';
	
	private  static var FAMILY_LIST:Array;
	private  static var MALE_LIST:Array;
	private  static var FEMAIL_LIST:Array;
	private  static var ALL_LIST:Array;
	private  static var EN_LIST:Array;
	private  static var NUM_LIST:Array;
	
	public function NameUtil()
	{
		
	}
	
	/**
	 * 初始化所有文字
	 */
	public static function init():void
	{
		FAMILY_LIST = FAMILY_NAME.split(',');
		MALE_LIST = MALE_LAST_NAME.split(',');
		FEMAIL_LIST = FEMALE_NAME.split(',');
		ALL_LIST = MALE_LIST.concat(FEMAIL_LIST);
		EN_LIST = ENGLISH_NAME.split(',');
		NUM_LIST = NUMBER_NAME.split(',');
	}
	
	
	/**
	 * 创建名字
	 * @return 创建的名字
	 */
	public static function createName():String
	{
		var length:int = Random.randint(1, 5);
		var name:String;
		switch(length)
		{
			case 2:
				name = NameUtil.createOneFirstName() + NameUtil.createOneWord();
				break;
			case 3:
				name = NameUtil.createOneFirstName() + NameUtil.createOneWord() + NameUtil.createOneWord();
				break;
			case 4:
				name = NameUtil.createOneWord() + NameUtil.createOneWord() + NameUtil.createOneEnWord() + NameUtil.createOneEnWord();
				break;
			case 5:
				name = NameUtil.createOneWord() + NameUtil.createOneWord() + NameUtil.createOneNumberWord() + NameUtil.createOneNumberWord() + NameUtil.createOneNumberWord();
				break;
			default:
				name = NameUtil.createOneEnWord() + NameUtil.createOneEnWord() + NameUtil.createOneEnWord() + NameUtil.createOneEnWord() + NameUtil.createOneEnWord();
				break;		
		}
		return name;
	}
	
	/**
	 * 创建在中文列表中取一个姓
	 * @return
	 */
	public static function createOneFirstName():String
	{
		return Random.sample(FAMILY_LIST, 1)[0];
	}
	
	/**
	 * 创建一个名
	 * @return
	 */
	public static function createOneWord():String
	{
		return Random.sample(ALL_LIST, 1)[0];
	}
	
	/**
	 * 创建一个英文字母
	 * @return
	 */
	public static function createOneEnWord():String
	{
		return Random.sample(EN_LIST, 1)[0];
	}
	
	/**
	 * 创建一个数字
	 * @return
	 */
	public static function createOneNumberWord():String
	{
		return Random.sample(EN_LIST, 1)[0];
	}
}
}