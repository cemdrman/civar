import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart' as ll;

import '../../app_state/feed_providers.dart';
import '../../app_state/location_providers.dart';
import '../../app_state/membership_providers.dart';
import '../../core/routing/route_paths.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/utils/geo_utils.dart';
import '../../domain/models/place.dart';
import '../../domain/models/post.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/place_pin.dart';
import 'widgets/place_preview_sheet.dart';

ll.LatLng _toLL(LatLng p) => ll.LatLng(p.lat, p.lng);

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  String? _selectedPlaceId;
  final _mapController = MapController();
  bool _centeredOnce = false;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

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

    if (!_centeredOnce && places.isNotEmpty) {
      _centeredOnce = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController.move(_toLL(viewer), 12);
      });
    }

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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.card),
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _toLL(viewer),
                        initialZoom: 12,
                        minZoom: 3,
                        maxZoom: 18,
                        onTap: (_, _) => setState(() => _selectedPlaceId = null),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.civar.civar',
                          maxZoom: 19,
                        ),
                        CircleLayer(
                          circles: [
                            for (final place in places)
                              CircleMarker(
                                point: _toLL(place.location),
                                radius: 60 + place.heat * 220,
                                useRadiusInMeter: true,
                                color: AppColors.accentSoft.withValues(alpha: 0.45),
                                borderStrokeWidth: 0,
                              ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _toLL(viewer),
                              width: 20,
                              height: 20,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.accentDark,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 2)),
                                  ],
                                ),
                              ),
                            ),
                            for (final place in places)
                              Marker(
                                point: _toLL(place.location),
                                width: 44,
                                height: 44,
                                alignment: Alignment.topCenter,
                                child: PlacePin(
                                  commentCount: posts.where((p) => p.placeId == place.id).length,
                                  onTap: () => setState(() => _selectedPlaceId = place.id),
                                ),
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8, right: 8),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: RichAttributionWidget(
                              attributions: [
                                TextSourceAttribution(
                                  'OpenStreetMap contributors',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: _RecenterButton(
                        onTap: () => _mapController.move(_toLL(viewer), 13),
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
                ),
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

class _RecenterButton extends StatelessWidget {
  const _RecenterButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
        ),
        child: const Icon(Icons.my_location, size: 18, color: AppColors.accentDark),
      ),
    );
  }
}
