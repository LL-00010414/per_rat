import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum Genre {
  action,
  adventure,
  boysLove,
  comedy,
  drama,
  fantasy,
  girlsLove,
  horror,
  mystery,
  romance,
  sciFi,
  sliceOfLife,
  sports,
  supernatural,
  ecchi,
  hentai,
}

enum Demographics {
  josei,
  kids,
  seinen,
  shoujo,
  shounen,
}

enum Studio {
  kinemaCitrus,
  cloverWorks,
  sentaiFilmworks,
  studioDeen,
  studioBind,
  a1Pictures,
  tatsunokoProduction,
  nipponTelevisionNetwork,
  showgate,
  dogaKobo,
  hololiveProduction,
  gallop,
  ufotable,
  aniplex,
  pierrot,
  shinEiAnimation,
  tencentPenguinPictures,
  shaft,
  silverLink,
  seven,
  witStudio,
  gainax,
  feel,
  discotekMedia,
  olm,
  bilibili,
  shogakukanShueishaProductions,
  gonzo,
  brainsBase,
  ashiProductions,
  aquaAris,
  studio4C,
  studioHibari,
  tmsEntertainment,
  aic,
  dle,
  xebec,
  kyotoAnimation,
  satelight,
  studioMausu,
  mappa,
  mushiProduction,
  maidenJapan,
  madhouse,
  tbs,
  bandaiEntertainment,
  nihonAdSystems,
  warnerBrosJapan,
  lidenfilms,
  geidaiAnimation,
  bsFuji,
  zexcs,
  studioComet,
}

enum Status {
  completed,
  ongoing,
  upcoming,
}

class Anime {
  Anime({
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.totalEpisodes,
    required this.score,
    required this.rank,
    required this.popularity,
    required this.trailerUrl,
    required this.genre,
    required this.demographics,
    required this.studio,
    required this.status,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final String imageUrl;
  final List<String> synopsis;
  final int totalEpisodes;
  final String score;
  final String rank;
  final String popularity;
  final String trailerUrl;
  final Genre genre;
  final Demographics demographics;
  final Studio studio;
  final Status status;
}
