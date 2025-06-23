file(REMOVE_RECURSE
  "QQMusic/MoveSlider.qml"
  "QQMusic/Player.qml"
  "QQMusic/Qbottom.qml"
  "QQMusic/Volume.qml"
  "QQMusic/main.qml"
  "QQMusic/source.qrc"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/appQQMusic_tooling.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
