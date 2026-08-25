import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app_state/feed_providers.dart';
import '../../app_state/location_providers.dart';
import '../../app_state/membership_providers.dart';
import '../../core/routing/route_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/utils/geo_utils.dart';
import '../../core/widgets/placeholder_box.dart';
import '../../domain/models/place.dart';
import '../../domain/models/post.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/place_pin.dart';
import 'widgets/place_preview_sheet.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  String? _selectedPlaceId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final placesAsync = ref.watch(placesStreamProvider);
    final postsAsync = ref.watch(allPostsStreamProvider);
    final tierAsync = ref.watch(currentTierProvider);
    final viewer = ref.watch(simulatedLocationProvider);

    final places = placesAsync.value ?? const <Place>[];
    final posts = postsAsync.value ?? const <Post>[];
    final tierLabel = tierAsync.value?.radiusLabel ?? '5 km';

    final selectedPlace =
        _selectedPlaceId == null ? null : places.where((p) => p.id == _selectedPlaceId).firstOrNull;

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.mapLabel, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.radiusSuffix(tierLabel),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: PlaceholderBox(label: l10n.mapPlaceholderLabel),
                      ),
                      for (final place in places)
                        _HeatCircle(place: place, canvasSize: constraints.biggest),
                      for (final place in places)
                        Positioned(
                          left: place.mapAnchor.dx * constraints.maxWidth - 8,
                          top: place.mapAnchor.dy * constraints.maxHeight - 8,
                          child: PlacePin(
                            commentCount: posts.where((p) => p.placeId == place.id).length,
                            onTap: () => setState(() => _selectedPlaceId = place.id),
                          ),
                        ),
                      if (selectedPlace != null)
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: _buildPreview(context, selectedPlace, posts, viewer),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview(BuildContext context, Place place, List<Post> posts, LatLng viewer) {
    final placePosts = posts.where((p) => p.placeId == place.id).toList();
    final teaser = placePosts.isEmpty
        ? AppLocalizations.of(context)!.noCommentsYetWriteFirst
        : placePosts.first.text;

    return PlacePreviewSheet(
      place: place,
      distanceKm: haversineKm(viewer, place.location),
      commentCount: placePosts.length,
      teaser: teaser,
      onClose: () => setState(() => _selectedPlaceId = null),
      onViewDetail: () {
        setState(() => _selectedPlaceId = null);
        context.push(RoutePaths.placeDetail(place.id));
      },
    );
  }
}

class _HeatCircle extends StatelessWidget {
  const _HeatCircle({required this.place, required this.canvasSize});

  final Place place;
  final Size canvasSize;

  @override
  Widget build(BuildContext context) {
    final size = 60 + place.heat * 220;
    return Positioned(
      left: place.mapAnchor.dx * canvasSize.width - size / 2,
      top: place.mapAnchor.dy * canvasSize.height - size / 2,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [AppColors.accentSoft.withValues(alpha: 0.9), AppColors.accentSoft.withValues(alpha: 0)],
              stops: const [0, 0.72],
            ),
          ),
        ),
      ),
    );
  }
}
