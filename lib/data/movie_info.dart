import 'package:per_rat/data/demographic_info.dart';
import 'package:per_rat/data/genre_info.dart';
import 'package:per_rat/data/status_info.dart';
import 'package:per_rat/data/studio_info.dart';
import 'package:per_rat/models/anime.dart';
import 'package:per_rat/models/demographics.dart';
import 'package:per_rat/models/genres.dart';
import 'package:per_rat/models/statuses.dart';
import 'package:per_rat/models/studios.dart';

final dummyAnime = [
  Anime(
    title: 'Mushoku Tensei',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1776/131746l.jpg',
    synopsis: [
      'After his relationship with Eris Boreas Greyrat reaches new heights, ',
      'Rudeus Greyrat is ecstatic. Unfortunately, his joy is short-lived, ',
      ' as Eris suddenly abandons him to embark on her own journey.',
      'Believing that Eris has lost all interest in him, a heartbroken and ',
      'depressed Rudeus sets forth to the Northern Territories. With his',
      'sole goal being to locate his mother on the vast continent, Rudeus wonders',
      'if persisting through daily life is worth the pain, falling into ',
      ' a robotic routine as he endlessly ruminates on his lost love.',
    ],
    totalEpisodes: 12,
    score: '8.53',
    rank: '111',
    popularity: '593',
    favorites: 5476,
    trailerUrl: 'https://youtu.be/tlDF3cfb8lA?si=6Cst_4qFRneqlprp',
    genre: genres[Genres.adventure]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.studioBind]!,
    status: statuses[Statuses.completed]!,
    startDate: DateTime(2019, 5, 4),
    endDate: DateTime(2023, 5, 4),
  ),
  Anime(
    title: 'Jujutsu Kaisen 2nd Season',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1676/128448l.jpg',
    synopsis: ['Second season of Jujutsu Kaisen'],
    totalEpisodes: 23,
    score: '8.82',
    rank: '30',
    popularity: '359',
    favorites: 9354,
    trailerUrl: 'https://youtu.be/PKHQuQF1S8k?si=nRhMvQuX3wZKvHTM',
    genre: genres[Genres.action]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.mappa]!,
    status: statuses[Statuses.ongoing]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Horimiya: The Missing Pieces',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1007/136277l.jpg',
    synopsis: [
      'As the graduation ceremony at Katagiri High School comes to an end, Kyouko Hori, '
          'her boyfriend Izumi Miyamura, and their friends begin to look back on their time as students. '
          'The moments they shared together may be fleeting, but each one is a colorful '
          'piece of their precious memories.'
    ],
    totalEpisodes: 13,
    score: '8.26',
    rank: '287',
    popularity: '927',
    favorites: 2053,
    trailerUrl: 'https://youtu.be/MU-Vk5R0vVY?si=8H_MNZr_zBwKXLnb',
    genre: genres[Genres.romance]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.cloverWorks]!,
    status: statuses[Statuses.completed]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Watashi no Shiawase na Kekkon',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1698/132259l.jpg',
    synopsis: [
      'Misery seems everlasting in Miyo Saimori\'s life. Born into an arranged marriage,'
          'she was quickly discarded after her mother\'s tragic death. '
          'Her father remarried, and her younger half-sister Kaya received all the affection, '
          'while Miyo was degraded to a lowly servant. Lacking the strength to fight against her '
          'family\'s abuse, Miyo loses hope that her luck will ever turn.'
    ],
    totalEpisodes: 12,
    score: '7.91',
    rank: '731',
    popularity: '1278',
    favorites: 2002,
    trailerUrl: 'https://youtu.be/dURh9kVzcw8',
    genre: genres[Genres.drama]!,
    demographic: demographics[Demographics.seinen]!,
    studio: studios[Studios.kinemaCitrus]!,
    status: statuses[Statuses.completed]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Tate no Yuusha no Nariagari Season 3',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1188/136926l.jpg',
    synopsis: ['Third season of Tate no Yuusha no Nariagari.'],
    totalEpisodes: 12,
    score: '7.69',
    rank: '1202',
    popularity: '660',
    favorites: 5422,
    trailerUrl: 'https://youtu.be/VW_LxM4tt-o',
    genre: genres[Genres.adventure]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.kinemaCitrus]!,
    status: statuses[Statuses.ongoing]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Goblin Slayer II',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1488/122008l.jpg',
    synopsis: ['Second season of Goblin Slayer.'],
    totalEpisodes: 0,
    score: '7.72',
    rank: '1124',
    popularity: '954',
    favorites: 2541,
    trailerUrl: 'https://youtu.be/Dc3U12kH3WA',
    genre: genres[Genres.action]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.lidenfilms]!,
    status: statuses[Statuses.ongoing]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Solo Leveling',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1542/124991l.jpg',
    synopsis: [
      'Ten years ago, "the Gate" appeared and connected the real world with the realm of magic and monsters.',
      'To combat these vile beasts, ordinary people received superhuman powers and became known as "Hunters." ',
      'Twenty-year-old Sung Jin-Woo is one such Hunter, but he is known as the "World\'s Weakest," ',
      'owing to his pathetic power compared to even a measly E-Rank. Still, he hunts monsters tirelessly ',
      'in low-rank Gates to pay for his mother\'s medical bills.'
    ],
    totalEpisodes: 0,
    score: 'N/A',
    rank: 'N/A',
    popularity: '1389',
    favorites: 3233,
    trailerUrl: 'https://youtu.be/sqtIagL463A',
    genre: genres[Genres.action]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.a1Pictures]!,
    status: statuses[Statuses.upcoming]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Classroom of the Elite III',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1280/137323l.jpg',
    synopsis: [
      '3rd season of Youkoso Jitsuryoku Shijou Shugi no Kyoushitsu e (TV).'
    ],
    totalEpisodes: 0,
    score: 'N/A',
    rank: 'N/A',
    popularity: '1504',
    favorites: 1269,
    trailerUrl: 'https://youtu.be/GWwSZdBeGAk?si=dllEHGWetGMcWFQk',
    genre: genres[Genres.mystery]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.lerche]!,
    status: statuses[Statuses.upcoming]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Mashle 2nd Season',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1593/136775l.jpg',
    synopsis: ['Second season of Mashle.'],
    totalEpisodes: 0,
    score: 'N/A',
    rank: 'N/A',
    popularity: '2674',
    favorites: 125,
    trailerUrl: 'https://youtu.be/zk0YBvw53MI',
    genre: genres[Genres.comedy]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.a1Pictures]!,
    status: statuses[Statuses.upcoming]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Tsukimichi -Moonlit Fantasy- Season 2',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1996/137082l.jpg',
    synopsis: ['Second Season of Tsuki ga Michibiku Isekai Douchuu.'],
    totalEpisodes: 0,
    score: 'N/A',
    rank: 'N/A',
    popularity: '2050',
    favorites: 743,
    trailerUrl: 'https://youtu.be/qe5D48JdTUc',
    genre: genres[Genres.mystery]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.lerche]!,
    status: statuses[Statuses.upcoming]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Mato Seihei no Slave',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1416/119501l.jpg',
    synopsis: [
      'When entrances to a different dimension known as the "Mato"',
      'emerge all over Japan, a new resource known as "Peaches" are discovered ',
      ',which give unique abilities only to women. However, dangerous monsters ',
      'called "Yomotsu Shuuki" also roam throughout the Mato and have been ',
      'responsible for various disasters ever since. To combat them, the',
      'government formed the Anti-demon Corps, an elite group of women ',
      'who have received power from the Peaches.'
    ],
    totalEpisodes: 0,
    score: 'N/A',
    rank: 'N/A',
    popularity: '3140',
    favorites: 457,
    trailerUrl: 'https://youtu.be/acDOHR_3L9c?si=kQ9OY47FYQXIsH2N',
    genre: genres[Genres.ecchi]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.seven]!,
    status: statuses[Statuses.upcoming]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Spy x Family Season 2',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1573/136206l.jpg',
    synopsis: [
      'Second season of Spy x Family.',
    ],
    totalEpisodes: 12,
    score: '8.45',
    rank: '149',
    popularity: '858',
    favorites: 1717,
    trailerUrl: 'https://youtu.be/30Dy3GERCqQ',
    genre: genres[Genres.comedy]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.witStudio]!,
    status: statuses[Statuses.ongoing]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Kage no Jitsuryokusha ni Naritakute! 2nd Season',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1892/133677l.jpg',
    synopsis: [
      'Everything has been going according to plan, but the hour of awakening draws near. ',
      'Cid Kagenou and Shadow Garden investigate the Lawless City, a cesspool where the ',
      'red moon hangs low in the sky and three powerful monarchs rule the streets. ',
      'The true draw for Cid, however, is one who can draw blood–the Blood Queen, ',
      'a vampire who has slumbered in her coffin for eons. Her awakening approaches, and',
      'Cid could finally face a day of reckoning.,',
    ],
    totalEpisodes: 12,
    score: '8.75',
    rank: '46',
    popularity: '1224',
    favorites: 1952,
    trailerUrl: 'https://youtu.be/OqzdUcc3k9Y',
    genre: genres[Genres.action]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.nexus]!,
    status: statuses[Statuses.ongoing]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Sousou no Frieren',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1553/137254l.jpg',
    synopsis: [
      'The demon king has been defeated, and the victorious hero party returns home ',
      'before disbanding. The four—mage Frieren, hero Himmel, priest Heiter, and warrior',
      'Eisen—reminisce about their decade-long journey as the moment to bid each other ',
      'farewell arrives. But the passing of time is different for elves, thus Frieren ',
      'witnesses her companions slowly pass away one by one.',
    ],
    totalEpisodes: 0,
    score: '8.94',
    rank: '17',
    popularity: '1261',
    favorites: 1774,
    trailerUrl: 'https://youtu.be/tR8YH0G67Rk',
    genre: genres[Genres.adventure]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.madhouse]!,
    status: statuses[Statuses.ongoing]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
  Anime(
    title: 'Tokyo Revengers: Tenjiku-hen',
    imageUrl: 'https://cdn.myanimelist.net/images/anime/1790/138322l.jpg',
    synopsis: [
      'Third season of Tokyo Revengers.',
    ],
    totalEpisodes: 13,
    score: '7.90',
    rank: '755',
    popularity: '1965',
    favorites: 523,
    trailerUrl: 'https://youtu.be/tR8YH0G67Rk',
    genre: genres[Genres.action]!,
    demographic: demographics[Demographics.shounen]!,
    studio: studios[Studios.lidenfilms]!,
    status: statuses[Statuses.ongoing]!,
    startDate: DateTime(2015, 5, 4),
    endDate: DateTime(2016, 5, 4),
  ),
];