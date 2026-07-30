# FRINKELS Production Readiness Plan

## Phase 1: Router
- [ ] Fix GoRouter configuration
- [ ] Fix redirects
- [ ] Fix refreshListenable
- [ ] Fix auth guards
- [ ] Fix splash navigation
- [ ] Run flutter analyze and fix errors

## Phase 2: Riverpod
- [ ] Fix duplicate providers
- [ ] Fix invalid provider types
- [ ] Fix WidgetRef vs Ref usage
- [ ] Fix ConsumerWidget/ConsumerState usage
- [ ] Run flutter analyze and fix errors

## Phase 3: Authentication
- [ ] Fix login flow
- [ ] Fix signup flow
- [ ] Fix forgot password flow
- [ ] Fix logout flow
- [ ] Fix session restore
- [ ] Run flutter analyze and fix errors

## Phase 4: Home
- [ ] Fix bottom navigation
- [ ] Fix feed section
- [ ] Fix weather section
- [ ] Fix news section
- [ ] Fix communities section
- [ ] Fix businesses section
- [ ] Fix profile section
- [ ] Run flutter analyze and fix errors

## Phase 5: Theme
- [ ] Fix missing imports
- [ ] Restore AppColors
- [ ] Restore AppTypography
- [ ] Run flutter analyze and fix errors

## Phase 6: Widgets
- [ ] Fix all type mismatches
- [ ] Fix nullable/non-nullable issues
- [ ] Fix deprecated APIs
- [ ] Run flutter analyze and fix errors

## Phase 7: Tests
- [ ] Update tests to match final router
- [ ] Run flutter test and fix failing tests

## Phase 8: Final Verification
- [ ] Run flutter analyze and confirm 0 errors
- [ ] Run flutter test and confirm all tests pass
- [ ] Run the app and verify every screen opens without crashes
- [ ] Verify every button navigates correctly
- [ ] Verify authentication flow works
- [ ] Confirm no navigation dead ends
- [ ] Confirm app no longer gets stuck on Home screen