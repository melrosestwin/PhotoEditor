import SwiftUI

struct TermsOfUseView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var storeManager = StoreManager.shared
    
    var body: some View {
        VStack {
            Text("TERMS OF USE")
                .font(.poppins(17.adaptive(), weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button {
                        dismiss()
                    } label: {
                            HStack(spacing: 5.adaptive()) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18.adaptive(), height: 24.adaptive())
                                Text("Return")
                                    .font(.poppins(17.adaptive()))
                            }
                            .foregroundStyle(.white)
                    }
                }
                .padding(.horizontal, 16.adaptive())
            
            ScrollView {
                VStack(spacing: 16.adaptive()) {
                    Text("AGREEMENT TO OUR LEGAL TERMS")
                        .font(.poppins(16.adaptive(), weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(termsText)
                        .font(.poppins(14.adaptive()))
                        .foregroundStyle(.white.opacity(0.85))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .padding(.horizontal, 16.adaptive())
                .padding(.vertical, 16.adaptive())
                .padding(.bottom, 16.adaptive())
            }
        }
        .padding(.vertical, 10.adaptive())
        .ignoresSafeArea(edges: .bottom)
        .setDefaultBackground(.secondary)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
    }

    let termsText = #"""
    We are KOVALAN GROUP LTD (“Company,” “we,” “us,” “our”), a company registered in England. We operate the Join Sport mobile application (the “App”), which uses AI-powered tools for photo processing, and any related services (collectively, the “Services”).

    Contact Information:

    Email: a.kovalenko@kovalangroup.pro

    Address: KOVALAN GROUP LTD, 2 Leman Street, London, England, E1 8FA

    Attn: Anna Kovalenko

    By accessing or using the Services, you agree to these Legal Terms. IF YOU DISAGREE, DO NOT USE THE SERVICES.
    OUR SERVICES
    The Services provide AI-based photo enhancement tools. They are not intended for use in jurisdictions where such services are restricted. You are responsible for compliance with local laws.


    INTELLECTUAL PROPERTY RIGHTS
    Our Ownership
    We own or license all intellectual property in the Services, including AI models, algorithms, software, logos, trademarks (“Join Sport”), and app design.


    Your License
    You may use the Services only for personal, non-commercial purposes. You may not reverse-engineer the AI technology or use processed images for commercial purposes without our permission.

    Your Content
    You retain ownership of uploaded photos. You grant us a non-exclusive, worldwide license to process your photos solely to operate the Services. We do not use your content to train AI models without your consent.
    USER REPRESENTATIONS
    By using the Services, you confirm that:


    You are at least 16 years old (or the age of majority in your jurisdiction).

    You own the rights to all uploaded content.

    You will not use the Services for illegal purposes (e.g., creating deepfakes).

    Parents/guardians of minors under 16 may contact us to delete their data.
    PROHIBITED ACTIVITIES
    You may not:


    Upload content that violates copyrights, contains nudity, hate speech, or illegal material.

    Use the AI to generate harmful or deceptive content (e.g., fake IDs).

    Exploit the Services for bulk processing (e.g., commercial photo editing).
    USER GENERATED CONTRIBUTIONS
    You are solely responsible for uploaded content. We may remove content that violates these Terms without notice.


    CONTRIBUTION LICENSE
    You grant us the right to temporarily store and process your photos only to provide the Services. We may retain anonymized metadata for improving AI performance.


    SERVICES MANAGEMENT
    We reserve the right to monitor for misuse (e.g., spam, bots) and disable accounts violating these Terms.


    TERM AND TERMINATION
    We may terminate your access immediately for violations. Banned users may not create new accounts.


    MODIFICATIONS AND INTERRUPTIONS
    Services may be updated or discontinued without notice. No refunds for interruptions (if the App is paid).


    GOVERNING LAW
    These Terms are governed by English law. EU consumers may file complaints with their local authorities.


    DISPUTE RESOLUTION
    Negotiation: Contact us within 30 days.


    Arbitration: Unresolved disputes go to the London Court of International Arbitration (LCIA).

    Exceptions: IP disputes may proceed to court.
    CORRECTIONS
    We may correct errors in AI outputs or Service descriptions.


    DISCLAIMER
    AI Limitations: Outputs may be inaccurate or unsuitable for critical use. We do not guarantee that processed images will meet your expectations.


    LIMITATIONS OF LIABILITY
    Our maximum liability: The amount you paid us in the last 6 months (if any). Not liable for damages from reliance on AI outputs or third-party misuse of your content.


    INDEMNIFICATION
    You agree to cover our legal costs if your use violates these Terms or infringes third-party rights.


    USER DATA
    Photos are stored for up to 24 hours after processing. See our Privacy Policy for data rights (e.g., deletion requests).


    ELECTRONIC COMMUNICATIONS
    You consent to receive notices electronically (e.g., via email).


    MISCELLANEOUS
    Severability: If one clause is invalid, the rest remain enforceable.


    No waiver: Our failure to enforce a rule does not waive it.
    CONTACT US
    For questions or complaints:
    Email: a.kovalenko@kovalangroup.pro
    Mail: KOVALAN GROUP LTD, 2 Leman Street, London, E1 8FA

    """#
}

#Preview {
    TermsOfUseView()
}
