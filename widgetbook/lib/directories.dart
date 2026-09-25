import 'package:widgetbook/widgetbook.dart';

import 'use_cases/buttons/button_use_cases.dart';
import 'use_cases/cards/card_use_cases.dart';
import 'use_cases/chips/chip_use_cases.dart';
import 'use_cases/dialogs/dialog_use_cases.dart';
import 'use_cases/feedback/badge_use_cases.dart';
import 'use_cases/feedback/empty_state_use_cases.dart';
import 'use_cases/feedback/loading_use_cases.dart';
import 'use_cases/feedback/rating_stars_use_cases.dart';
import 'use_cases/feedback/skeleton_use_cases.dart';
import 'use_cases/feedback/status_pill_use_cases.dart';
import 'use_cases/feedback/toast_use_cases.dart';
import 'use_cases/inputs/password_field_use_cases.dart';
import 'use_cases/inputs/phone_field_use_cases.dart';
import 'use_cases/inputs/text_field_use_cases.dart';
import 'use_cases/layout/app_bar_use_cases.dart';
import 'use_cases/layout/divider_use_cases.dart';
import 'use_cases/layout/header_title_use_cases.dart';
import 'use_cases/layout/list_tile_use_cases.dart';
import 'use_cases/layout/page_dots_use_cases.dart';
import 'use_cases/layout/page_header_use_cases.dart';
import 'use_cases/layout/progress_stepper_use_cases.dart';
import 'use_cases/layout/pullable_empty_use_cases.dart';
import 'use_cases/layout/section_header_use_cases.dart';
import 'use_cases/media/avatar_use_cases.dart';
import 'use_cases/media/glass_label_use_cases.dart';
import 'use_cases/media/network_image_use_cases.dart';
import 'use_cases/media/svg_icon_use_cases.dart';
import 'use_cases/pickers/dob_picker_use_cases.dart';
import 'use_cases/pickers/height_picker_use_cases.dart';
import 'use_cases/pickers/photo_crop_page_use_cases.dart';
import 'use_cases/pickers/year_picker_use_cases.dart';

/// Assembles the folder tree shown in the Widgetbook sidebar, in the same
/// order as the root README's catalogue.
final directories = <WidgetbookNode>[
  WidgetbookFolder(name: 'buttons', children: buttonComponents),
  WidgetbookFolder(name: 'cards', children: cardComponents),
  WidgetbookFolder(name: 'chips', children: chipComponents),
  WidgetbookFolder(name: 'dialogs', children: dialogComponents),
  WidgetbookFolder(
    name: 'feedback',
    children: [
      ...badgeComponents,
      ...emptyStateComponents,
      ...loadingComponents,
      ...ratingStarsComponents,
      ...skeletonComponents,
      ...toastComponents,
      ...statusPillComponents,
    ],
  ),
  WidgetbookFolder(
    name: 'inputs',
    children: [
      ...textFieldComponents,
      ...passwordFieldComponents,
      ...phoneFieldComponents,
    ],
  ),
  WidgetbookFolder(
    name: 'layout',
    children: [
      ...appBarComponents,
      ...dividerComponents,
      ...headerTitleComponents,
      ...pageHeaderComponents,
      ...pageDotsComponents,
      ...sectionHeaderComponents,
      ...listTileComponents,
      ...progressStepperComponents,
      ...pullableEmptyComponents,
    ],
  ),
  WidgetbookFolder(
    name: 'media',
    children: [
      ...avatarComponents,
      ...glassLabelComponents,
      ...networkImageComponents,
      ...svgIconComponents,
    ],
  ),
  WidgetbookFolder(
    name: 'pickers',
    children: [
      ...dobPickerComponents,
      ...heightPickerComponents,
      ...yearPickerComponents,
      ...photoCropPageComponents,
    ],
  ),
];
