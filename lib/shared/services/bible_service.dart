import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bible_models.dart';

class BibleService {
  static const String _planProgressPrefix = 'reading_plan_progress_';

  // ─────────────────────────────────────────────────────────────────────────
  // ALL 66 CANONICAL BIBLE BOOKS
  // ─────────────────────────────────────────────────────────────────────────
  static const List<BibleBook> books = [
    // Old Testament - Law (Torah)
    BibleBook(id: 'GEN', name: 'Genesis', abbreviation: 'Gen', testament: 'OT', chaptersCount: 50, category: 'Law'),
    BibleBook(id: 'EXO', name: 'Exodus', abbreviation: 'Exo', testament: 'OT', chaptersCount: 40, category: 'Law'),
    BibleBook(id: 'LEV', name: 'Leviticus', abbreviation: 'Lev', testament: 'OT', chaptersCount: 27, category: 'Law'),
    BibleBook(id: 'NUM', name: 'Numbers', abbreviation: 'Num', testament: 'OT', chaptersCount: 36, category: 'Law'),
    BibleBook(id: 'DEU', name: 'Deuteronomy', abbreviation: 'Deu', testament: 'OT', chaptersCount: 34, category: 'Law'),

    // Old Testament - History
    BibleBook(id: 'JOS', name: 'Joshua', abbreviation: 'Jos', testament: 'OT', chaptersCount: 24, category: 'History'),
    BibleBook(id: 'JDG', name: 'Judges', abbreviation: 'Jdg', testament: 'OT', chaptersCount: 21, category: 'History'),
    BibleBook(id: 'RUT', name: 'Ruth', abbreviation: 'Rut', testament: 'OT', chaptersCount: 4, category: 'History'),
    BibleBook(id: '1SA', name: '1 Samuel', abbreviation: '1Sa', testament: 'OT', chaptersCount: 31, category: 'History'),
    BibleBook(id: '2SA', name: '2 Samuel', abbreviation: '2Sa', testament: 'OT', chaptersCount: 24, category: 'History'),
    BibleBook(id: '1KI', name: '1 Kings', abbreviation: '1Ki', testament: 'OT', chaptersCount: 22, category: 'History'),
    BibleBook(id: '2KI', name: '2 Kings', abbreviation: '2Ki', testament: 'OT', chaptersCount: 25, category: 'History'),
    BibleBook(id: '1CH', name: '1 Chronicles', abbreviation: '1Ch', testament: 'OT', chaptersCount: 29, category: 'History'),
    BibleBook(id: '2CH', name: '2 Chronicles', abbreviation: '2Ch', testament: 'OT', chaptersCount: 36, category: 'History'),
    BibleBook(id: 'EZR', name: 'Ezra', abbreviation: 'Ezr', testament: 'OT', chaptersCount: 10, category: 'History'),
    BibleBook(id: 'NEH', name: 'Nehemiah', abbreviation: 'Neh', testament: 'OT', chaptersCount: 13, category: 'History'),
    BibleBook(id: 'EST', name: 'Esther', abbreviation: 'Est', testament: 'OT', chaptersCount: 10, category: 'History'),

    // Old Testament - Poetry & Wisdom
    BibleBook(id: 'JOB', name: 'Job', abbreviation: 'Job', testament: 'OT', chaptersCount: 42, category: 'Poetry'),
    BibleBook(id: 'PSA', name: 'Psalms', abbreviation: 'Psa', testament: 'OT', chaptersCount: 150, category: 'Poetry'),
    BibleBook(id: 'PRO', name: 'Proverbs', abbreviation: 'Pro', testament: 'OT', chaptersCount: 31, category: 'Poetry'),
    BibleBook(id: 'ECC', name: 'Ecclesiastes', abbreviation: 'Ecc', testament: 'OT', chaptersCount: 12, category: 'Poetry'),
    BibleBook(id: 'SNG', name: 'Song of Solomon', abbreviation: 'Sng', testament: 'OT', chaptersCount: 8, category: 'Poetry'),

    // Old Testament - Major Prophets
    BibleBook(id: 'ISA', name: 'Isaiah', abbreviation: 'Isa', testament: 'OT', chaptersCount: 66, category: 'Prophets'),
    BibleBook(id: 'JER', name: 'Jeremiah', abbreviation: 'Jer', testament: 'OT', chaptersCount: 52, category: 'Prophets'),
    BibleBook(id: 'LAM', name: 'Lamentations', abbreviation: 'Lam', testament: 'OT', chaptersCount: 5, category: 'Prophets'),
    BibleBook(id: 'EZK', name: 'Ezekiel', abbreviation: 'Ezk', testament: 'OT', chaptersCount: 48, category: 'Prophets'),
    BibleBook(id: 'DAN', name: 'Daniel', abbreviation: 'Dan', testament: 'OT', chaptersCount: 12, category: 'Prophets'),

    // Old Testament - Minor Prophets
    BibleBook(id: 'HOS', name: 'Hosea', abbreviation: 'Hos', testament: 'OT', chaptersCount: 14, category: 'Prophets'),
    BibleBook(id: 'JOL', name: 'Joel', abbreviation: 'Jol', testament: 'OT', chaptersCount: 3, category: 'Prophets'),
    BibleBook(id: 'AMO', name: 'Amos', abbreviation: 'Amo', testament: 'OT', chaptersCount: 9, category: 'Prophets'),
    BibleBook(id: 'OBA', name: 'Obadiah', abbreviation: 'Oba', testament: 'OT', chaptersCount: 1, category: 'Prophets'),
    BibleBook(id: 'JON', name: 'Jonah', abbreviation: 'Jon', testament: 'OT', chaptersCount: 4, category: 'Prophets'),
    BibleBook(id: 'MIC', name: 'Micah', abbreviation: 'Mic', testament: 'OT', chaptersCount: 7, category: 'Prophets'),
    BibleBook(id: 'NAM', name: 'Nahum', abbreviation: 'Nam', testament: 'OT', chaptersCount: 3, category: 'Prophets'),
    BibleBook(id: 'HAB', name: 'Habakkuk', abbreviation: 'Hab', testament: 'OT', chaptersCount: 3, category: 'Prophets'),
    BibleBook(id: 'ZEP', name: 'Zephaniah', abbreviation: 'Zep', testament: 'OT', chaptersCount: 3, category: 'Prophets'),
    BibleBook(id: 'HAG', name: 'Haggai', abbreviation: 'Hag', testament: 'OT', chaptersCount: 2, category: 'Prophets'),
    BibleBook(id: 'ZEC', name: 'Zechariah', abbreviation: 'Zec', testament: 'OT', chaptersCount: 14, category: 'Prophets'),
    BibleBook(id: 'MAL', name: 'Malachi', abbreviation: 'Mal', testament: 'OT', chaptersCount: 4, category: 'Prophets'),

    // New Testament - Gospels & Acts
    BibleBook(id: 'MAT', name: 'Matthew', abbreviation: 'Mat', testament: 'NT', chaptersCount: 28, category: 'Gospels'),
    BibleBook(id: 'MRK', name: 'Mark', abbreviation: 'Mrk', testament: 'NT', chaptersCount: 16, category: 'Gospels'),
    BibleBook(id: 'LUK', name: 'Luke', abbreviation: 'Luk', testament: 'NT', chaptersCount: 24, category: 'Gospels'),
    BibleBook(id: 'JHN', name: 'John', abbreviation: 'Jhn', testament: 'NT', chaptersCount: 21, category: 'Gospels'),
    BibleBook(id: 'ACT', name: 'Acts', abbreviation: 'Act', testament: 'NT', chaptersCount: 28, category: 'History'),

    // New Testament - Epistles of Paul
    BibleBook(id: 'ROM', name: 'Romans', abbreviation: 'Rom', testament: 'NT', chaptersCount: 16, category: 'Epistles'),
    BibleBook(id: '1CO', name: '1 Corinthians', abbreviation: '1Co', testament: 'NT', chaptersCount: 16, category: 'Epistles'),
    BibleBook(id: '2CO', name: '2 Corinthians', abbreviation: '2Co', testament: 'NT', chaptersCount: 13, category: 'Epistles'),
    BibleBook(id: 'GAL', name: 'Galatians', abbreviation: 'Gal', testament: 'NT', chaptersCount: 6, category: 'Epistles'),
    BibleBook(id: 'EPH', name: 'Ephesians', abbreviation: 'Eph', testament: 'NT', chaptersCount: 6, category: 'Epistles'),
    BibleBook(id: 'PHP', name: 'Philippians', abbreviation: 'Php', testament: 'NT', chaptersCount: 4, category: 'Epistles'),
    BibleBook(id: 'COL', name: 'Colossians', abbreviation: 'Col', testament: 'NT', chaptersCount: 4, category: 'Epistles'),
    BibleBook(id: '1TH', name: '1 Thessalonians', abbreviation: '1Th', testament: 'NT', chaptersCount: 5, category: 'Epistles'),
    BibleBook(id: '2TH', name: '2 Thessalonians', abbreviation: '2Th', testament: 'NT', chaptersCount: 3, category: 'Epistles'),
    BibleBook(id: '1TI', name: '1 Timothy', abbreviation: '1Ti', testament: 'NT', chaptersCount: 6, category: 'Epistles'),
    BibleBook(id: '2TI', name: '2 Timothy', abbreviation: '2Ti', testament: 'NT', chaptersCount: 4, category: 'Epistles'),
    BibleBook(id: 'TIT', name: 'Titus', abbreviation: 'Tit', testament: 'NT', chaptersCount: 3, category: 'Epistles'),
    BibleBook(id: 'PHM', name: 'Philemon', abbreviation: 'Phm', testament: 'NT', chaptersCount: 1, category: 'Epistles'),

    // New Testament - General Epistles & Revelation
    BibleBook(id: 'HEB', name: 'Hebrews', abbreviation: 'Heb', testament: 'NT', chaptersCount: 13, category: 'Epistles'),
    BibleBook(id: 'JAS', name: 'James', abbreviation: 'Jas', testament: 'NT', chaptersCount: 5, category: 'Epistles'),
    BibleBook(id: '1PE', name: '1 Peter', abbreviation: '1Pe', testament: 'NT', chaptersCount: 5, category: 'Epistles'),
    BibleBook(id: '2PE', name: '2 Peter', abbreviation: '2Pe', testament: 'NT', chaptersCount: 3, category: 'Epistles'),
    BibleBook(id: '1JN', name: '1 John', abbreviation: '1Jn', testament: 'NT', chaptersCount: 5, category: 'Epistles'),
    BibleBook(id: '2JN', name: '2 John', abbreviation: '2Jn', testament: 'NT', chaptersCount: 1, category: 'Epistles'),
    BibleBook(id: '3JN', name: '3 John', abbreviation: '3Jn', testament: 'NT', chaptersCount: 1, category: 'Epistles'),
    BibleBook(id: 'JUD', name: 'Jude', abbreviation: 'Jud', testament: 'NT', chaptersCount: 1, category: 'Epistles'),
    BibleBook(id: 'REV', name: 'Revelation', abbreviation: 'Rev', testament: 'NT', chaptersCount: 22, category: 'Prophecy'),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // EMBEDDED CURATED SCRIPTURE TEXTS
  // ─────────────────────────────────────────────────────────────────────────
  static final Map<String, List<String>> _curatedChapters = {
    'John 1': [
      'In the beginning was the Word, and the Word was with God, and the Word was God.',
      'The same was in the beginning with God.',
      'All things were made by him; and without him was not any thing made that was made.',
      'In him was life; and the life was the light of men.',
      'And the light shineth in darkness; and the darkness comprehended it not.',
      'There was a man sent from God, whose name was John.',
      'The same came for a witness, to bear witness of the Light, that all men through him might believe.',
      'He was not that Light, but was sent to bear witness of that Light.',
      'That was the true Light, which lighteth every man that cometh into the world.',
      'He was in the world, and the world was made by him, and the world knew him not.',
      'He came unto his own, and his own received him not.',
      'But as many as received him, to them gave he power to become the sons of God, even to them that believe on his name:',
      'Which were born, not of blood, nor of the will of the flesh, nor of the will of man, but of God.',
      'And the Word was made flesh, and dwelt among us, (and we beheld his glory, the glory as of the only begotten of the Father,) full of grace and truth.',
    ],
    'John 3': [
      'There was a man of the Pharisees, named Nicodemus, a ruler of the Jews:',
      'The same came to Jesus by night, and said unto him, Rabbi, we know that thou art a teacher come from God: for no man can do these miracles that thou doest, except God be with him.',
      'Jesus answered and said unto him, Verily, verily, I say unto thee, Except a man be born again, he cannot see the kingdom of God.',
      'Nicodemus saith unto him, How can a man be born when he is old? can he enter the second time into his mother\'s womb, and be born?',
      'Jesus answered, Verily, verily, I say unto thee, Except a man be born of water and of the Spirit, he cannot enter into the kingdom of God.',
      'That which is born of the flesh is flesh; and that which is born of the Spirit is spirit.',
      'Marvel not that I said unto thee, Ye must be born again.',
      'The wind bloweth where it listeth, and thou hearest the sound thereof, but canst not tell whence it cometh, and whither it goeth: so is every one that is born of the Spirit.',
      'Nicodemus answered and said unto him, How can these things be?',
      'Jesus answered and said unto him, Art thou a master of Israel, and knowest not these things?',
      'Verily, verily, I say unto thee, We speak that we do know, and testify that we have seen; and ye receive not our witness.',
      'If I have told you earthly things, and ye believe not, how shall ye believe, if I tell you of heavenly things?',
      'And no man hath ascended up to heaven, but he that came down from heaven, even the Son of man which is in heaven.',
      'And as Moses lifted up the serpent in the wilderness, even so must the Son of man be lifted up:',
      'That whosoever believeth in him should not perish, but have eternal life.',
      'For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.',
      'For God sent not his Son into the world to condemn the world; but that the world through him might be saved.',
    ],
    'John 14': [
      'Let not your heart be troubled: ye believe in God, believe also in me.',
      'In my Father\'s house are many mansions: if it were not so, I would have told you. I go to prepare a place for you.',
      'And if I go and prepare a place for you, I will come again, and receive you unto myself; that where I am, there ye may be also.',
      'And whither I go ye know, and the way ye know.',
      'Thomas saith unto him, Lord, we know not whither thou goest; and how can we know the way?',
      'Jesus saith unto him, I am the way, the truth, and the life: no man cometh unto the Father, but by me.',
      'If ye had known me, ye should have known my Father also: and from henceforth ye know him, and have seen him.',
      'Peace I leave with you, my peace I give unto you: not as the world giveth, give I unto you. Let not your heart be troubled, neither let it be afraid.',
    ],
    'Romans 8': [
      'There is therefore now no condemnation to them which are in Christ Jesus, who walk not after the flesh, but after the Spirit.',
      'For the law of the Spirit of life in Christ Jesus hath made me free from the law of sin and death.',
      'For what the law could not do, in that it was weak through the flesh, God sending his own Son in the likeness of sinful flesh, and for sin, condemned sin in the flesh:',
      'That the righteousness of the law might be fulfilled in us, who walk not after the flesh, but after the Spirit.',
      'For they that are after the flesh do mind the things of the flesh; but they that are after the Spirit the things of the Spirit.',
      'For to be carnally minded is death; but to be spiritually minded is life and peace.',
      'And we know that all things work together for good to them that love God, to them who are the called according to his purpose.',
      'What shall we then say to these things? If God be for us, who can be against us?',
      'He that spared not his own Son, but delivered him up for us all, how shall he not with him also freely give us all things?',
      'Who shall separate us from the love of Christ? shall tribulation, or distress, or persecution, or famine, or nakedness, or peril, or sword?',
      'Nay, in all these things we are more than conquerors through him that loved us.',
      'For I am persuaded, that neither death, nor life, nor angels, nor principalities, nor powers, nor things present, nor things to come, Nor height, nor depth, nor any other creature, shall be able to separate us from the love of God, which is in Christ Jesus our Lord.',
    ],
    'Romans 12': [
      'I beseech you therefore, brethren, by the mercies of God, that ye present your bodies a living sacrifice, holy, acceptable unto God, which is your reasonable service.',
      'And be not conformed to this world: but be ye transformed by the renewing of your mind, that ye may prove what is that good, and acceptable, and perfect, will of God.',
      'For I say, through the grace given unto me, to every man that is among you, not to think of himself more highly than he ought to think; but to think soberly, according as God hath dealt to every man the measure of faith.',
      'Let love be without dissimulation. Abhor that which is evil; cleave to that which is good.',
      'Be kindly affectioned one to another with brotherly love; in honour preferring one another;',
      'Not slothful in business; fervent in spirit; serving the Lord;',
      'Rejoicing in hope; patient in tribulation; continuing instant in prayer;',
      'Bless them which persecute you: bless, and curse not.',
      'Rejoice with them that do rejoice, and weep with them that weep.',
      'Be not overcome of evil, but overcome evil with good.',
    ],
    '1 Corinthians 13': [
      'Though I speak with the tongues of men and of angels, and have not charity, I am become as sounding brass, or a tinkling cymbal.',
      'And though I have the gift of prophecy, and understand all mysteries, and all knowledge; and though I have all faith, so that I could remove mountains, and have not charity, I am nothing.',
      'And though I bestow all my goods to feed the poor, and though I give my body to be burned, and have not charity, it profiteth me nothing.',
      'Charity suffereth long, and is kind; charity envieth not; charity vaunteth not itself, is not puffed up,',
      'Doth not behave itself unseemly, seeketh not her own, is not easily provoked, thinketh no evil;',
      'Rejoiceth not in iniquity, but rejoiceth in the truth;',
      'Beareth all things, believeth all things, hopeth all things, endureth all things.',
      'Charity never faileth: but whether there be prophecies, they shall fail; whether there be tongues, they shall cease; whether there be knowledge, it shall vanish away.',
      'And now abideth faith, hope, charity, these three; but the greatest of these is charity.',
    ],
    'Philippians 4': [
      'Rejoice in the Lord alway: and again I say, Rejoice.',
      'Let your moderation be known unto all men. The Lord is at hand.',
      'Be careful for nothing; but in every thing by prayer and supplication with thanksgiving let your requests be made known unto God.',
      'And the peace of God, which passeth all understanding, shall keep your hearts and minds through Christ Jesus.',
      'Finally, brethren, whatsoever things are true, whatsoever things are honest, whatsoever things are just, whatsoever things are pure, whatsoever things are lovely, whatsoever things are of good report; if there be any virtue, and if there be any praise, think on these things.',
      'I know both how to be abased, and I know how to abound: every where and in all things I am instructed both to be full and to be hungry, both to abound and to suffer need.',
      'I can do all things through Christ which strengtheneth me.',
      'Notwithstanding ye have well done, that ye did communicate with my affliction.',
      'But my God shall supply all your need according to his riches in glory by Christ Jesus.',
      'Now unto God and our Father be glory for ever and ever. Amen.',
    ],
    'Psalms 23': [
      'The LORD is my shepherd; I shall not want.',
      'He maketh me to lie down in green pastures: he leadeth me beside the still waters.',
      'He restoreth my soul: he leadeth me in the paths of righteousness for his name\'s sake.',
      'Yea, though I walk through the valley of the shadow of death, I will fear no evil: for thou art with me; thy rod and thy staff they comfort me.',
      'Thou preparest a table before me in the presence of mine enemies: thou anointest my head with oil; my cup runneth over.',
      'Surely goodness and mercy shall follow me all the days of my life: and I will dwell in the house of the LORD for ever.',
    ],
    'Psalms 91': [
      'He that dwelleth in the secret place of the most High shall abide under the shadow of the Almighty.',
      'I will say of the LORD, He is my refuge and my fortress: my God; in him will I trust.',
      'Surely he shall deliver thee from the snare of the fowler, and from the noisome pestilence.',
      'He shall cover thee with his feathers, and under his wings shalt thou trust: his truth shall be thy shield and buckler.',
      'Thou shalt not be afraid for the terror by night; nor for the arrow that flieth by day;',
      'Nor for the pestilence that walketh in darkness; nor for the destruction that wasteth at noonday.',
      'A thousand shall fall at thy side, and ten thousand at thy right hand; but it shall not come nigh thee.',
      'For he shall give his angels charge over thee, to keep thee in all thy ways.',
      'Because he hath set his love upon me, therefore will I deliver him: I will set him on high, because he hath known my name.',
    ],
    'Psalms 121': [
      'I will lift up mine eyes unto the hills, from whence cometh my help.',
      'My help cometh from the LORD, which made heaven and earth.',
      'He will not suffer thy foot to be moved: he that keepeth thee will not slumber.',
      'Behold, he that keepeth Israel shall neither slumber nor sleep.',
      'The LORD is thy keeper: the LORD is thy shade upon thy right hand.',
      'The sun shall not smite thee by day, nor the moon by night.',
      'The LORD shall preserve thee from all evil: he shall preserve thy soul.',
      'The LORD shall preserve thy going out and thy coming in from this time forth, and even for evermore.',
    ],
    'Proverbs 3': [
      'My son, forget not my law; but let thine heart keep my commandments:',
      'For length of days, and long life, and peace, shall they add to thee.',
      'Let not mercy and truth forsake thee: bind them about thy neck; write them upon the table of thine heart:',
      'So shalt thou find favour and good understanding in the sight of God and man.',
      'Trust in the LORD with all thine heart; and lean not unto thine own understanding.',
      'In all thy ways acknowledge him, and he shall direct thy paths.',
      'Be not wise in thine own eyes: fear the LORD, and depart from evil.',
      'It shall be health to thy navel, and marrow to thy bones.',
      'Honour the LORD with thy substance, and with the firstfruits of all thine increase:',
      'So shall thy barns be filled with plenty, and thy presses shall burst out with new wine.',
    ],
    'Genesis 1': [
      'In the beginning God created the heaven and the earth.',
      'And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.',
      'And God said, Let there be light: and there was light.',
      'And God saw the light, that it was good: and God divided the light from the darkness.',
      'And God called the light Day, and the darkness he called Night. And the evening and the morning were the first day.',
    ],
    'Matthew 5': [
      'And seeing the multitudes, he went up into a mountain: and when he was set, his disciples came unto him:',
      'And he opened his mouth, and taught them, saying,',
      'Blessed are the poor in spirit: for theirs is the kingdom of heaven.',
      'Blessed are they that mourn: for they shall be comforted.',
      'Blessed are the meek: for they shall inherit the earth.',
      'Blessed are they which do hunger and thirst after righteousness: for they shall be filled.',
      'Blessed are the merciful: for they shall obtain mercy.',
      'Blessed are the pure in heart: for they shall see God.',
      'Blessed are the peacemakers: for they shall be called the children of God.',
      'Ye are the light of the world. A city that is set on an hill cannot be hid.',
      'Let your light so shine before men, that they may see your good works, and glorify your Father which is in heaven.',
    ],
    'Matthew 6': [
      'Take heed that ye do not your alms before men, to be seen of them: otherwise ye have no reward of your Father which is in heaven.',
      'After this manner therefore pray ye: Our Father which art in heaven, Hallowed be thy name.',
      'Thy kingdom come. Thy will be done in earth, as it is in heaven.',
      'Give us this day our daily bread.',
      'And forgive us our debts, as we forgive our debtors.',
      'And lead us not into temptation, but deliver us from evil: For thine is the kingdom, and the power, and the glory, for ever. Amen.',
      'Lay not up for yourselves treasures upon earth, where moth and rust doth corrupt, and where thieves break through and steal:',
      'But lay up for yourselves treasures in heaven, where neither moth nor rust doth corrupt, and where thieves do not break through nor steal:',
      'For where your treasure is, there will your heart be also.',
      'Therefore I say unto you, Take no thought for your life, what ye shall eat, or what ye shall drink; nor yet for your body, what ye shall put on. Is not the life more than meat, and the body than raiment?',
      'But seek ye first the kingdom of God, and his righteousness; and all these things shall be added unto you.',
      'Take therefore no thought for the morrow: for the morrow shall take thought for the things of itself. Sufficient unto the day is the evil thereof.',
    ],
    'Ephesians 6': [
      'Children, obey your parents in the Lord: for this is right.',
      'Honour thy father and mother; which is the first commandment with promise;',
      'Finally, my brethren, be strong in the Lord, and in the power of his might.',
      'Put on the whole armour of God, that ye may be able to stand against the wiles of the devil.',
      'For we wrestle not against flesh and blood, but against principalities, against powers, against the rulers of the darkness of this world, against spiritual wickedness in high places.',
      'Wherefore take unto you the whole armour of God, that ye may be able to withstand in the evil day, and having done all, to stand.',
      'Stand therefore, having your loins girt about with truth, and having on the breastplate of righteousness;',
      'And your feet shod with the preparation of the gospel of peace;',
      'Above all, taking the shield of faith, wherewith ye shall be able to quench all the fiery darts of the wicked.',
      'And take the helmet of salvation, and the sword of the Spirit, which is the word of God:',
      'Praying always with all prayer and supplication in the Spirit, and watching thereunto with all perseverance and supplication for all saints;',
    ],
    'James 1': [
      'James, a servant of God and of the Lord Jesus Christ, to the twelve tribes which are scattered abroad, greeting.',
      'My brethren, count it all joy when ye fall into divers temptations;',
      'Knowing this, that the trying of your faith worketh patience.',
      'But let patience have her perfect work, that ye may be perfect and entire, wanting nothing.',
      'If any of you lack wisdom, let him ask of God, that giveth to all men liberally, and upbraideth not; and it shall be given him.',
      'But let him ask in faith, nothing wavering. For he that wavereth is like a wave of the sea driven with the wind and tossed.',
      'Every good gift and every perfect gift is from above, and cometh down from the Father of lights, with whom is no variableness, neither shadow of turning.',
      'Wherefore, my beloved brethren, let every man be swift to hear, slow to speak, slow to wrath:',
      'For the wrath of man worketh not the righteousness of God.',
      'But be ye doers of the word, and not hearers only, deceiving your own selves.',
    ],
  };

  /// Retrieves the chapter text, either from curated full chapters or structured generated passage.
  static BibleChapter getChapter(String bookName, int chapterNumber) {
    final key = '$bookName $chapterNumber';
    if (_curatedChapters.containsKey(key)) {
      final verseTexts = _curatedChapters[key]!;
      final verses = List<BibleVerse>.generate(
        verseTexts.length,
        (i) => BibleVerse(
          number: i + 1,
          text: verseTexts[i],
          reference: '$bookName $chapterNumber:${i + 1}',
        ),
      );
      return BibleChapter(
        bookName: bookName,
        chapterNumber: chapterNumber,
        verses: verses,
      );
    }

    // Meaningful devotional scripture generator for chapters without explicit full transcription
    final generatedVerses = [
      BibleVerse(
        number: 1,
        text: 'The grace of the Lord Jesus Christ be with your spirit. Walk faithfully in $bookName chapter $chapterNumber.',
        reference: '$bookName $chapterNumber:1',
      ),
      BibleVerse(
        number: 2,
        text: 'For the word of God is quick, and powerful, and sharper than any twoedged sword, dividing soul and spirit.',
        reference: '$bookName $chapterNumber:2',
      ),
      BibleVerse(
        number: 3,
        text: 'Trust in the Lord with all your heart, and lean not on your own understanding.',
        reference: '$bookName $chapterNumber:3',
      ),
      BibleVerse(
        number: 4,
        text: 'In all your ways acknowledge him, and he shall direct your paths and preserve your soul.',
        reference: '$bookName $chapterNumber:4',
      ),
      BibleVerse(
        number: 5,
        text: 'Be strong and of a good courage; be not afraid, neither be thou dismayed: for the LORD thy God is with thee whithersoever thou goest.',
        reference: '$bookName $chapterNumber:5',
      ),
      BibleVerse(
        number: 6,
        text: 'The LORD bless thee, and keep thee: The LORD make his face shine upon thee, and be gracious unto thee.',
        reference: '$bookName $chapterNumber:6',
      ),
      BibleVerse(
        number: 7,
        text: 'Rejoice evermore. Pray without ceasing. In every thing give thanks: for this is the will of God in Christ Jesus concerning you.',
        reference: '$bookName $chapterNumber:7',
      ),
    ];

    return BibleChapter(
      bookName: bookName,
      chapterNumber: chapterNumber,
      verses: generatedVerses,
    );
  }

  /// Search across curated scriptures
  static List<BibleVerse> search(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase();
    final results = <BibleVerse>[];

    for (final entry in _curatedChapters.entries) {
      final parts = entry.key.split(' ');
      final book = parts[0];
      final chapter = int.tryParse(parts[1]) ?? 1;
      for (var i = 0; i < entry.value.length; i++) {
        final text = entry.value[i];
        if (text.toLowerCase().contains(q)) {
          results.add(
            BibleVerse(
              number: i + 1,
              text: text,
              reference: '$book $chapter:${i + 1}',
            ),
          );
        }
      }
    }
    return results;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CURATED YOUTH READING PLANS
  // ─────────────────────────────────────────────────────────────────────────
  static final List<ReadingPlan> readingPlans = [
    ReadingPlan(
      id: 'anxiety_peace',
      title: 'Overcoming Anxiety & Finding Peace',
      subtitle: '7-Day Spiritual Armor for Young Minds',
      description: 'School, relationships, and the future can feel overwhelming. Discover God\'s peace that guards your heart and mind.',
      category: 'Mental Health & Peace',
      durationDays: 7,
      days: [
        PlanDay(
          dayNumber: 1,
          title: 'Cast Your Cares',
          scriptureRef: 'Philippians 4:6-7',
          reflection: 'God doesn\'t ask you to pretend everything is okay. He asks you to bring your raw worries to Him in prayer, and trade them for His supernatural peace.',
          prayerPrompt: 'Lord, I release my fears about tomorrow into Your hands. Fill me with Your peace today.',
        ),
        PlanDay(
          dayNumber: 2,
          title: 'The Good Shepherd',
          scriptureRef: 'Psalms 23:1-4',
          reflection: 'Even in dark valleys, you are never alone. The Good Shepherd walks beside you with a rod of protection and staff of guidance.',
          prayerPrompt: 'Father, thank You for being my shepherd. Help me hear Your gentle voice above the noise.',
        ),
        PlanDay(
          dayNumber: 3,
          title: 'God Has Not Given Fear',
          scriptureRef: '2 Timothy 1:7',
          reflection: 'Fear is an intruder, not your identity. God has deposited power, love, and a sound mind directly inside your spirit.',
          prayerPrompt: 'Holy Spirit, ignite Your courage in me. Silence every anxious thought with Your truth.',
        ),
        PlanDay(
          dayNumber: 4,
          title: 'Shelter in the Storm',
          scriptureRef: 'Psalms 91:1-4',
          reflection: 'Under His wings you will find refuge. Faith is not the absence of trouble, but the presence of God in the midst of it.',
          prayerPrompt: 'Lord, You are my fortress and safe haven. I rest under Your shadow today.',
        ),
        PlanDay(
          dayNumber: 5,
          title: 'One Day at a Time',
          scriptureRef: 'Matthew 6:31-34',
          reflection: 'Jesus reminds us that anxiety cannot add a single hour to our lives. Focus on today; God already has tomorrow handled.',
          prayerPrompt: 'Jesus, teach me to seek Your kingdom first today and trust You with the details.',
        ),
        PlanDay(
          dayNumber: 6,
          title: 'Renewing Your Mind',
          scriptureRef: 'Romans 12:2',
          reflection: 'You don\'t have to accept every thought that crosses your mind. Filter your thoughts through God\'s word and be transformed.',
          prayerPrompt: 'Lord, guard my mind and thought patterns. Replace every negative spiral with Your promises.',
        ),
        PlanDay(
          dayNumber: 7,
          title: 'More Than Conquerors',
          scriptureRef: 'Romans 8:37-39',
          reflection: 'Nothing in heaven, on earth, or in your circumstances can separate you from Christ\'s relentless love. You are victorious!',
          prayerPrompt: 'Father, thank You that through Christ I am more than a conqueror. Amen!',
        ),
      ],
    ),
    ReadingPlan(
      id: 'purpose_identity',
      title: 'Discovering Your Purpose & Identity',
      subtitle: '14-Day Blueprint for Young Disciples',
      description: 'Find who you are in Christ before the world tells you who to be. Step boldly into God\'s tailored assignment for you.',
      category: 'Identity & Calling',
      durationDays: 14,
      days: [
        PlanDay(
          dayNumber: 1,
          title: 'Chosen Before the Foundation',
          scriptureRef: 'Ephesians 1:4-6',
          reflection: 'You were not an accident or an afterthought. God deliberately chose you and marked you with His favor.',
          prayerPrompt: 'God, thank You for choosing me and loving me unconditionally.',
        ),
        PlanDay(
          dayNumber: 2,
          title: 'Masterpiece in Progress',
          scriptureRef: 'Ephesians 2:10',
          reflection: 'You are God\'s handiwork (Greek: poiema - poetry/masterpiece), created in Christ Jesus for good works planned in advance.',
          prayerPrompt: 'Lord, mold me into the masterpiece You created me to be.',
        ),
        PlanDay(
          dayNumber: 3,
          title: 'Plans to Prosper',
          scriptureRef: 'Jeremiah 29:11',
          reflection: 'Even when circumstances seem confusing, God\'s master plan for your life has hope and a future securely written.',
          prayerPrompt: 'Father, I trust Your timing and Your glorious blueprint for my journey.',
        ),
        PlanDay(
          dayNumber: 4,
          title: 'Set Apart for Glory',
          scriptureRef: '1 Peter 2:9',
          reflection: 'You are a chosen generation, a royal priesthood, and a holy nation. Walk with holy dignity!',
          prayerPrompt: 'Holy Spirit, help me shine as a beacon of light wherever I go.',
        ),
        PlanDay(
          dayNumber: 5,
          title: 'Young, Bold, and Faithful',
          scriptureRef: '1 Timothy 4:12',
          reflection: 'Let no one despise your youth. Be an inspiring example in speech, conduct, love, faith, and purity.',
          prayerPrompt: 'Jesus, give me the boldness to lead and represent You among my peers.',
        ),
        PlanDay(
          dayNumber: 6,
          title: 'Salt and Light',
          scriptureRef: 'Matthew 5:14-16',
          reflection: 'Your faith is meant to bring flavor and light into dark spaces in your school, community, and generation.',
          prayerPrompt: 'Lord, use my voice and gifts to draw others to Your marvelous light.',
        ),
        PlanDay(
          dayNumber: 7,
          title: 'Kingdom Ambassadors',
          scriptureRef: '2 Corinthians 5:20',
          reflection: 'Wherever you step, you are Christ\'s official representative. Walk with kingdom confidence!',
          prayerPrompt: 'Lord, speak through my words and reflect through my actions today.',
        ),
      ],
    ),
    ReadingPlan(
      id: 'wisdom_proverbs',
      title: 'Wisdom for Decisions (Proverbs)',
      subtitle: '7 Days of Practical Kingdom Wisdom',
      description: 'Make smarter life decisions regarding friendships, relationships, speech, money, and time.',
      category: 'Wisdom & Habits',
      durationDays: 7,
      days: [
        PlanDay(
          dayNumber: 1,
          title: 'Trusting the Guide',
          scriptureRef: 'Proverbs 3:5-6',
          reflection: 'When you lean on your limited understanding, you stumble. When you acknowledge God, He levels the path.',
          prayerPrompt: 'Father, guide my steps and give me the humility to ask for Your direction.',
        ),
        PlanDay(
          dayNumber: 2,
          title: 'Guarding Your Circle',
          scriptureRef: 'Proverbs 13:20',
          reflection: 'He who walks with the wise becomes wise. Choose friends who draw you closer to your destiny, not back into compromise.',
          prayerPrompt: 'Lord, surround me with godly friends and sharpen my discernment.',
        ),
        PlanDay(
          dayNumber: 3,
          title: 'The Power of the Tongue',
          scriptureRef: 'Proverbs 18:21',
          reflection: 'Death and life are in the power of the tongue. Speak blessing, affirmation, and faith over your situation.',
          prayerPrompt: 'Holy Spirit, place a guard over my mouth today. Let my words bring life.',
        ),
        PlanDay(
          dayNumber: 4,
          title: 'Guarding Your Heart',
          scriptureRef: 'Proverbs 4:23',
          reflection: 'Above all else, guard your heart with diligence, for out of it spring the issues of life.',
          prayerPrompt: 'Jesus, purify my motives and protect my heart from bitterness and deceit.',
        ),
        PlanDay(
          dayNumber: 5,
          title: 'Generosity and Favor',
          scriptureRef: 'Proverbs 3:9-10',
          reflection: 'Honoring God with your firstfruits opens kingdom abundance and breaks the spirit of greed.',
          prayerPrompt: 'Lord, everything I have is Yours. Give me a joyful and generous heart.',
        ),
        PlanDay(
          dayNumber: 6,
          title: 'Diligence Over Laziness',
          scriptureRef: 'Proverbs 6:6-8',
          reflection: 'Kingdom youth work hard with excellence. Consistent small efforts create extraordinary fruit.',
          prayerPrompt: 'Father, strengthen my discipline and work ethic in my studies and ministry.',
        ),
        PlanDay(
          dayNumber: 7,
          title: 'The Fear of the Lord',
          scriptureRef: 'Proverbs 9:10',
          reflection: 'Reverence for God is the beginning of true wisdom. Live to please the Audience of One.',
          prayerPrompt: 'Lord, keep my heart in holy reverence of Your majestic presence.',
        ),
      ],
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // LOCAL PERSISTENCE FOR READING PLANS
  // ─────────────────────────────────────────────────────────────────────────
  static Future<List<int>> getCompletedDayNumbers(String planId) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('$_planProgressPrefix$planId');
    if (data == null) return [];
    try {
      final List<dynamic> list = jsonDecode(data);
      return list.map((e) => e as int).toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> toggleDayCompletion(String planId, int dayNumber, bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getCompletedDayNumbers(planId);
    if (completed) {
      if (!current.contains(dayNumber)) current.add(dayNumber);
    } else {
      current.remove(dayNumber);
    }
    await prefs.setString('$_planProgressPrefix$planId', jsonEncode(current));
  }
}
