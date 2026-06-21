import 'package:kazumi_tmdb/modules/characters/character_item.dart';
import 'package:kazumi_tmdb/modules/characters/actor_item.dart';
import 'package:kazumi_tmdb/modules/staff/staff_item.dart';
import 'package:kazumi_tmdb/modules/comments/comment_item.dart';

class TMDBConverter {
  static const _tmdbImageBase = 'https://image.tmdb.org/t/p';

  static CharacterAvator _makeAvator(String? profilePath) {
    final path = (profilePath != null && profilePath.isNotEmpty)
        ? '$_tmdbImageBase/w185$profilePath'
        : '';
    return CharacterAvator(small: path, medium: path, grid: path, large: path);
  }

  static ActorAvator _makeActorAvator(String? profilePath) {
    final path = (profilePath != null && profilePath.isNotEmpty)
        ? '$_tmdbImageBase/w185$profilePath'
        : '';
    return ActorAvator(small: path, medium: path, grid: path, large: path);
  }

  static Images _makeStaffImages(String? profilePath) {
    final path = (profilePath != null && profilePath.isNotEmpty)
        ? '$_tmdbImageBase/w185$profilePath'
        : '';
    return Images(large: path, medium: path, small: path, grid: path);
  }

  static UserAvatar _makeUserAvatar(String? avatarPath) {
    final path = (avatarPath != null && avatarPath.isNotEmpty)
        ? avatarPath.startsWith('/')
            ? '$_tmdbImageBase/w185$avatarPath'
            : avatarPath.substring(0, 4) == 'http'
                ? avatarPath
                : '$_tmdbImageBase/w185$avatarPath'
        : '';
    return UserAvatar(small: path, medium: path, large: path);
  }

  static List<CharacterItem> convertCastToCharacterItems(List cast) {
    return cast.asMap().entries.map((entry) {
      final idx = entry.key;
      final item = entry.value as Map<String, dynamic>;
      final characterName = (item['character'] as String?) ?? '';
      final actorName = (item['name'] as String?) ?? '';
      final profilePath = item['profile_path'] as String?;
      final displayName =
          characterName.isNotEmpty ? '$characterName ($actorName)' : actorName;

      return CharacterItem(
        id: (item['id'] as int?) ?? idx,
        type: 1,
        name: displayName,
        relation: idx < 3 ? '主角' : '配角',
        avator: _makeAvator(profilePath),
        actorList: [
          ActorItem(
            id: (item['id'] as int?) ?? idx,
            type: 1,
            name: actorName,
            avator: _makeActorAvator(profilePath),
          ),
        ],
        info: CharacterExtraInfo(nameCn: '', summary: ''),
      );
    }).toList();
  }

  static List<StaffFullItem> convertCrewToStaffItems(List crew) {
    return crew.asMap().entries.map((entry) {
      final idx = entry.key;
      final item = entry.value as Map<String, dynamic>;
      final crewName = (item['name'] as String?) ?? '';
      final job = (item['job'] as String?) ?? '';
      final profilePath = item['profile_path'] as String?;

      return StaffFullItem(
        staff: Staff(
          id: (item['id'] as int?) ?? idx + 100000,
          name: crewName,
          nameCN: '',
          type: 1,
          info: job,
          comment: 0,
          lock: false,
          nsfw: false,
          images: _makeStaffImages(profilePath),
        ),
        positions: [
          Position(
            type: PositionType(id: 0, en: job, cn: job, jp: ''),
            summary: '',
            appearEps: '',
          ),
        ],
      );
    }).toList();
  }

  static List<CommentItem> convertReviewsToCommentItems(List reviews) {
    return reviews.asMap().entries.map((entry) {
      final item = entry.value as Map<String, dynamic>;
      final authorDetails =
          item['author_details'] as Map<String, dynamic>? ?? {};
      final username = (authorDetails['username'] as String?) ?? '';
      final name = (authorDetails['name'] as String?) ?? username;
      final avatarPath = authorDetails['avatar_path'] as String?;
      final ratingVal = (authorDetails['rating'] as num?)?.toDouble() ?? 0;
      final content = (item['content'] as String?) ?? '';
      final createdAt = item['created_at'] as String? ?? '';

      int timestamp = 0;
      if (createdAt.isNotEmpty) {
        timestamp = DateTime.tryParse(createdAt)?.millisecondsSinceEpoch ?? 0;
      }

      return CommentItem(
        user: User(
          id: username.hashCode,
          username: username,
          nickname: name.isNotEmpty ? name : username,
          avatar: _makeUserAvatar(avatarPath),
          sign: '',
          joinedAt: 0,
        ),
        comment: Comment(
          rate: ratingVal > 0 ? (ratingVal * 10).toInt() : 0,
          comment: content,
          updatedAt: timestamp,
        ),
      );
    }).toList();
  }
}
