import 'package:ui/ui.dart';

class Triangle extends CustomPainter {
  const Triangle({required this.isSent});

  final bool isSent;

  @override
  void paint(Canvas canvas, Size size) {
    final painter = Paint()
      ..color = AppColors.green
      ..style = PaintingStyle.fill;
    final path = Path();
    if (isSent) {
      path
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..conicTo(
          size.width,
          size.height,
          size.width * 0.8,
          size.height * 0.8,
          0.5,
        )
        ..arcToPoint(Offset(0, 0), radius: Radius.circular(8), clockwise: true)
        ..close();
    } else {
      path
        ..moveTo(size.width, 0)
        ..lineTo(size.width, size.height)
        ..conicTo(0, size.height, size.width * 0.2, size.height * 0.8, 0.5)
        ..arcToPoint(
          Offset(size.width, 0),
          radius: const Radius.circular(8),
          clockwise: false,
        )
        ..close();
    }

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SentMessage extends StatelessWidget {
  const SentMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(right: 16, left: 64, top: 4, bottom: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                  ),
                  child: Text(message),
                ),
              ),
              const CustomPaint(
                painter: Triangle(isSent: true),
                size: Size(10, 10),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class ReceivedMessage extends StatelessWidget {
  const ReceivedMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(right: 64, left: 16, top: 4, bottom: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const CustomPaint(
                painter: Triangle(isSent: false),
                size: Size(10, 10),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                  ),
                  child: Text(message),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
