import Foundation

class WordValidator {
    // 1) Lade die komplette Liste aus de_full.txt
    private static let germanWords: Set<String> = {
        guard let url = Bundle.main.url(
                forResource: "de_full",
                withExtension: "txt"
              ),
              let text = try? String(contentsOf: url, encoding: .utf8)
        else {
            print("⚠️ de_full.txt nicht gefunden!")
            return []
        }
        // 2) Jede Zeile trimmen, lowercase, nur ≥4 Zeichen
        return Set(
            text
              .components(separatedBy: .newlines)
              .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
              .filter { $0.count >= 4 }
        )
    }()

    /// Gibt true, wenn das Wort in der Liste ist
    static func isValid(_ word: String) -> Bool {
        let w = word.lowercased()
        return germanWords.contains(w)
    }
}
