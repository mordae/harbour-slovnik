TEMPLATE = app
TARGET   = harbour-slovnik

CONFIG  += sailfishapp

SOURCES += \
	src/main.cpp

OTHER_FILES = \
	rpm/harbour-slovnik.yaml \
	rpm/harbour-slovnik.spec \
	qml/main.qml \
	qml/pages/Select.qml \
	qml/pages/api.js
