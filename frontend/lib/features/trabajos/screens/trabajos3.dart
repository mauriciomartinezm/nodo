import 'package:flutter/material.dart';
import 'package:nodo/features/chat/screens/Chat1.dart';
import 'package:nodo/features/trabajos/screens/trabajos4.dart';
class DetalleTrabajoScreen extends StatefulWidget {
  final Map<String, dynamic> job;
  final ScrollController scrollController;

  const DetalleTrabajoScreen({
    Key? key,
    required this.job,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<DetalleTrabajoScreen> createState() => _DetalleTrabajoScreenState();
}

class _DetalleTrabajoScreenState extends State<DetalleTrabajoScreen> {
  String selectedAction = 'postularme';
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.job["images"] as List<String>? ?? [];
    final String clienteNombre = widget.job["user"].toString().split(' ').first;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(top: 12, bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: ListView(
                controller: widget.scrollController,
                padding: EdgeInsets.zero,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 200,
                        child: PageView.builder(
                          itemCount: images.length,
                          onPageChanged: (index) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            return Image.asset(
                              images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: 
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ReportarScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.flag, size: 16),
                          label: const Text("Reportar"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            textStyle: const TextStyle(fontSize: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (images.length > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentPage == index
                                  ? const Color(0xFF003366)
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.job["title"],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.job["description"],
                          style: const TextStyle(fontSize: 15, height: 1.4),
                        ),
                        const SizedBox(height: 8),
                        Text(widget.job["location"], style: TextStyle(color: Colors.grey[700])),
                        Text(
                          widget.job["time"],
                          style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.job["price"],
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(height: 32),
                        const Text(
                          "Información del cliente",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundImage: AssetImage('assets/icons/iconNodoBlue.png'),
                              radius: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.job["user"],
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => selectedAction = 'postularme');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedAction == 'postularme'
                            ? const Color(0xFF003366)
                            : Colors.grey[300],
                        foregroundColor: selectedAction == 'postularme'
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: const Text("Postularme"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() => selectedAction = 'hablar');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedAction == 'hablar'
                            ? const Color(0xFF003366)
                            : Colors.grey[300],
                        foregroundColor: selectedAction == 'hablar'
                            ? Colors.white
                            : Colors.black,
                      ),
                      child: Text(
                        "Hablar con $clienteNombre",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
