import 'dart:ui';

import 'package:flutter/material.dart';

const kAppTitle = TextStyle(
  fontFamily: 'electric_1',
  fontWeight: FontWeight.w700,
  fontSize: 18,
);

const kTimelineBlogTitle = TextStyle(
  fontWeight: FontWeight.w700,
);

const kTimelineBlogType = TextStyle(
  fontWeight: FontWeight.w500,
  color: Colors.redAccent,
);

const kReadingBlogTitle = TextStyle(
  fontWeight: FontWeight.w800,
  fontSize: 22,
);

const kReadingBlogDetail = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  fontFeatures: [
    FontFeature.oldstyleFigures(),
  ],
);

const kReadingBlogAuthor = TextStyle(
  fontWeight: FontWeight.bold,
);

const kReadingBlogTimeLike = TextStyle(
  fontWeight: FontWeight.w500,
);

const kWarningText = TextStyle(
  color: Colors.red,
);

const kCurrentUserBlogTitle = TextStyle(
  fontWeight: FontWeight.w800,
  fontSize: 18,
);

const kHeartIcon = Icon(
  Icons.favorite_border,
);
const kFillHeartIcon = Icon(
  Icons.favorite,
  color: Colors.red,
);
