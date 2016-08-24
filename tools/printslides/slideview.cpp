/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QML Presentation System.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/


#include <QtQml>
#include <QQuickItem>
#include <QDebug>
#include <QPixmap>
#include <QScreen>
#include "slideview.h"

SlideView::SlideView(QWindow* parent): QQuickView(parent),
m_slidesLeft(0), m_printedSlides(0), m_isFinished(false), m_printCurrentSlide(true) {
    connect (this, SIGNAL(statusChanged(QQuickView::Status)),
        this, SLOT(updateStatus(QQuickView::Status)));
}

void SlideView::updateStatus(QQuickView::Status status) {
    if (m_slidesLeft > 0) return;
    if (status != QQuickView::Ready) return;
    QQuickItem *ri = rootObject();
    QString superClass = ri->metaObject()->superClass()->className();
    if (!superClass.startsWith("Presentation")) {
        qWarning("Warning: Superclass appears to not be a Presentation: %s. ", superClass.toLocal8Bit().constData());
    }
    else qDebug() << "Found qml Presentation as rootObject";

    // Note: This is now done via "shouldPrint"-Callback
    //ri->setProperty("allowDelay", QVariant(false)); // Disable partial reveals on slide pages.
    QList<QVariant> slides = ri->property("slides").toList();
    m_slidesLeft = slides.size();
    qDebug() << "SlideCount: " << m_slidesLeft;
    qDebug() << "Printer's Page rect size (and suggested resolution of your presentation): " << m_printer.pageRect().size();

    //m_printer.setOrientation(QPrinter::Landscape);
    m_printer.setFullPage(true);
    m_printer.setOutputFileName("slides.pdf");
    m_printer.setPaperSize(QSizeF(rootObject()->width(), rootObject()->height()-19), QPrinter::DevicePixel);
    m_painter.begin(&m_printer);

    // it would be better if we used the printer resolution here and forced
    // the presentation to be in the same resolution but when I try that,
    // the timer doesn't work properly for some reason?

    setHeight(ri->height());
    setWidth(ri->width());

    // Try uncommenting the below 4 lines and see what happens.
    //setHeight(m_printer.pageRect().height());
    //setWidth(m_printer.pageRect().width());
    //ri->setHeight(height());
    //ri->setWidth(width());

    // start timer to print out pages once every 2 seconds.
    m_tid = startTimer(2500);
}

void SlideView::timerEvent(QTimerEvent*) {
    bool addAPage = false;
    if(m_printCurrentSlide)
    {
        printCurrentSlide();
        ++m_printedSlides;
        addAPage = true;
    }
    m_printCurrentSlide = goToNextSlide();
    //--m_slidesLeft;
    //if (m_slidesLeft > 0) {
    //}
    //else {
    if(m_isFinished) {
        killTimer(m_tid);
        m_painter.end();
        qDebug() << "Printed to file: " << m_printer.outputFileName();
        qApp->exit();
    }
    else if(addAPage)
    {
        m_printer.newPage();
    }

}


void SlideView::printCurrentSlide() {
    QImage pix = grabWindow();
    qDebug() << "Printing slide#" << m_printedSlides + 1 << "Resolution:" << pix.size();

    // support for sorting 9999 png's by name. Please don't create longer presentations :).
    QString filename = QString("slide") + QString::number(m_printedSlides).rightJustified(4, '0') + ".png";
    QImage cpy = pix.scaled(pix.width(), pix.height());
    cpy.save(filename, "PNG", 10 );

    QRect pageRect = m_printer.pageRect();
    QSize targetSize = pix.size();
    if((pageRect.width() != targetSize.width()) || (pageRect.height() != targetSize.height()))
    {
        qDebug() << "WARNING: scaling from " << pageRect << "to" << targetSize;
    }
    targetSize.scale(pageRect.width(), pageRect.height(), Qt::KeepAspectRatio);

    m_painter.drawImage(QRectF(pageRect.topLeft(), targetSize), pix);
}

bool SlideView::goToNextSlide() {
    static const QMetaObject* meta = rootObject()->metaObject();
    QList<QVariant> slides = rootObject()->property("slides").toList();
    QVariant shouldPrint;
    QVariant contin;
    meta->invokeMethod(rootObject(), "goToNextSlide", Q_RETURN_ARG(QVariant, contin));
    m_isFinished = !contin.toBool();
    if(m_isFinished) return true;
    QQuickItem* slid = qvariant_cast<QQuickItem*>( slides.at(rootObject()->property("currentSlide").toInt()) );
    if(slid == NULL) return false;
    const QMetaObject* smeta = slid->metaObject();
    smeta->invokeMethod(slid, "shouldPrint", Q_RETURN_ARG(QVariant, shouldPrint));
    return shouldPrint.toBool();
}
