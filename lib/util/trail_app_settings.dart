// Copyright (c) 2020, Fermented Software.
import 'package:alabama_beer_trail/data/trail_place_category.dart';
import 'package:flutter/material.dart';

class TrailAppSettings {
  // Primary Colors
  static const Color mainHeadingColor = Color(0xFF93654E);
  static const Color subHeadingColor = Color(0xFF4E7C93);
  static const Color actionLinksColor = Color(0xFF5A934E);
  static const Color attentionColor = Color(0xFF874E93);
  static const Color errorColor = Colors.red;

  // Assets
  static final String signInBackgroundAsset = "assets/images/signin_bkg.jpg";

  // Theme colors
  static final MaterialColor themePrimarySwatch =
      MaterialColor(mainHeadingColor.value, {
    50: mainHeadingColor.withOpacity(0.1),
    100: mainHeadingColor.withOpacity(0.2),
    200: mainHeadingColor.withOpacity(0.3),
    300: mainHeadingColor.withOpacity(0.4),
    400: mainHeadingColor.withOpacity(0.5),
    500: mainHeadingColor.withOpacity(0.6),
    600: mainHeadingColor.withOpacity(0.7),
    700: mainHeadingColor.withOpacity(0.8),
    800: mainHeadingColor.withOpacity(0.9),
    900: mainHeadingColor.withOpacity(1),
  });
  static final Color navBarBackgroundColor = mainHeadingColor;
  static final Color navBarSelectedItemColor = Colors.white70;

  // Sign In Screen
  static final String signInAppBarTitle = "Sign In";
  static final Color signInSignInButtonColor = actionLinksColor;
  static final Color signInForgotPwdColor = actionLinksColor;
  static final String signInButtonText = "Sign In";

  // Strings
  static final String appName = "Alabama Beer Trail";
  static final String navBarTrailTabTitle = "Alabama Beer Trail";
  static final String navBarTrailLabel = "Trail";
  static final String navBarEventsTabTitle = "Alabama Beer Events";
  static final String navBarEventsLabel = "Events";
  static final String navBarNewsTabTitle = "Alabama Beer News";
  static final String navBarNewsLabel = "News";
  static final String navBarAchievementsLabel = "Badges";
  static final String navBarAchievementsTabTitle = "Achievements";

  // Colors
  static final Color first = Color(0xFF93654E);
  static final Color second = Color(0xFF5A934E);
  static final Color third = Color(0xFF4E7C93);
  static final Color fourth = Color(0xFF874E93);

  // Icons
  static final IconData navBarTrailIcon = Icons.location_on;
  static final IconData navBarEventsIcon = Icons.calendar_today;
  static final IconData navBarNewsIcon = Icons.rss_feed;
  static final IconData navBarAchievementsIcon = Icons.emoji_events;

  // Events Tab Options
  static final List<double> eventFilterDistances = [5, 25, 50, 100];

  // Place Detail Options
  static final bool showNonMemberTapList = true;

  // Other Options
  static final bool navBarShowSelectedLabels = true;
  static final bool navBarShowUnselectedLabels = false;
  static final String newsScreenRssFeedUrl =
      'https://freethehops.org/category/app-publish/feed/';
  static final String defaultNewsThumbnailAsset =
      'assets/images/newsfeed_empty_image.jpg';
  static final int locationUpdatesIntervalMs = 5000;
  static final double locationUpdatesDisplacementThreshold = 10;
  static final double minDistanceToCheckin = 0.10;
  static final List<TrailPlaceCategory> filterStrings = <TrailPlaceCategory>[
    TrailPlaceCategory("Brewery", "Breweries"),
    TrailPlaceCategory("Distillery", "Distilleries"),
    TrailPlaceCategory("Tasting Room", "Tasting Rooms",
      description: "A Tasting Room means that the brewery or distillery is licensed to sell only alcoholic beverages that it manufactures on location."),    
    TrailPlaceCategory("Open Bar", "Open Bars",
      description: "An Open Bar means that the brewery or distillery is licensed to have guest taps and to sell other alcoholic beverages"),
    TrailPlaceCategory("Restaurant", "Restaurants",
      description: "Within the app, a Restaurant means a full kitchen, menu, and table service"),
  ];
  static final String defaultBannerImageAssetLocation =
      'assets/images/fthglasses.jpg';
  static final String defaultDisplayName = " ";
  static final String defaultProfilePhotoAssetLocation =
      'assets/images/defaultprofilephoto.png';

  static final String privacyPolicyUrl = "https://freethehops.org/apps/alabama-beer-trail-privacy-policy/";
  static final String submitFeedbackUrl = "https://freethehops.org/apps/submit-feedback/";

  /// About page
  static final String aboutScreenFbPageId = '178685318846986';
  static final String aboutScreenTwitterLink = 'https://twitter.com/freethehops';
  static final String aboutScreenInstagramLink = 'https://www.instagram.com/freethehops/';
  static final String aboutScreenWebsiteLink = 'https://freethehops.org';

  static final String privacyPolicyHtml = '''
<div>
<p>&nbsp;</p>
<p><center><strong><span data-custom-class="title">PRIVACY NOTICE   </span>  </strong></center></p>
<p><strong><span data-custom-class="subtitle">Last updated July 03, 2020</span></strong></p>
<p><span data-custom-class="body_text">Thank you for choosing to be part of our community at Alabama Brewers Guild, Inc, doing business as Free the Hops (“<strong>Free the Hops</strong>”, “<strong>we</strong>”, “<strong>us</strong>”, or “<strong>our</strong>”). We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about our notice, or our practices with regards to your personal information, please contact us at <a href="mailto:info@freethehops.org">info@freethehops.org</a>.</span></p>
<p><span data-custom-class="body_text">When you use our mobile application, and use our services, you trust us with your personal information. We take your privacy very seriously. In this privacy notice, we seek to explain to you in the clearest way possible what information we collect, how we use it and what rights you have in relation to it. We hope you take some time to read through it carefully, as it is important. If there are any terms in this privacy notice that you do not agree with, please discontinue use of our Apps and our services.</span></p>
<p><span data-custom-class="body_text">This privacy notice applies to all information collected through our mobile application, </span><span data-custom-class="body_text">(&#8220;<strong>Apps</strong>&#8220;), and/or any related services, sales, marketing or events (we refer to them collectively in this privacy notice as the &#8220;<strong>Services</strong>&#8220;). </span></p>
<p><strong><span data-custom-class="body_text">Please read this privacy notice carefully as it will help you make informed decisions about sharing your personal information with us. </span> </strong></p>
<p><strong><span data-custom-class="heading_1">TABLE OF CONTENTS</span> </strong></p>
<p>1. WHAT INFORMATION DO WE COLLECT?</p>
<p>2. HOW DO WE USE YOUR INFORMATION?</p>
<p>3. WILL YOUR INFORMATION BE SHARED WITH ANYONE?</p>
<p>4. HOW DO WE HANDLE YOUR SOCIAL LOGINS?</p>
<p>5. HOW LONG DO WE KEEP YOUR INFORMATION?</p>
<p>6. HOW DO WE KEEP YOUR INFORMATION SAFE?</p>
<p>7. DO WE COLLECT INFORMATION FROM MINORS?</p>
<p>8. WHAT ARE YOUR PRIVACY RIGHTS?</p>
<p>9. CONTROLS FOR DO-NOT-TRACK FEATURES</p>
<p>10. DO CALIFORNIA RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?</p>
<p>11. DO WE MAKE UPDATES TO THIS POLICY?</p>
<p>12. HOW CAN YOU CONTACT US ABOUT THIS POLICY?</p>
<hr />
<p id="infocollect"><strong><span data-custom-class="heading_1">1. WHAT INFORMATION DO WE COLLECT?</span> </strong></p>
<p><strong><span data-custom-class="heading_2">Information automatically collected</span></strong></p>
<p><strong><em><span data-custom-class="body_text">In Short:</span></em> </strong><em><span data-custom-class="body_text">Some information – such as IP address and/or browser and device characteristics – is collected automatically when you use our Apps.</span></em></p>
<p><span data-custom-class="body_text">We automatically collect certain information when you visit, use or navigate the Apps. This information does not reveal your specific identity (like your name or contact information) but may include device and usage information, such as your IP address, browser and device characteristics, operating system, language preferences, referring URLs, device name, country, location, information about how and when you use our Apps and other technical information. This information is primarily needed to maintain the security and operation of our Apps, and for our internal analytics and reporting purposes.</span></p>
<p><strong><span data-custom-class="heading_2">Information collected through our Apps</span></strong></p>
<p><strong><em><span data-custom-class="body_text">In Short:</span></em>  </strong><em><span data-custom-class="body_text">We may collect information regarding your geo-location, mobile device, push notifications, date of birth, and email address when you use our apps.</span></em></p>
<p><span data-custom-class="body_text">If you use our Apps, we may also collect the following information:</span></p>
<ul>
<li><em><span data-custom-class="body_text">Geo-Location Information.</span></em><span data-custom-class="body_text"> We may request access or permission to and track location-based information from your mobile device, either continuously or while you are using our mobile application, to provide location-based services. If you wish to change our access or permissions, you may do so in your device’s settings.</span></li>
<li><em><span data-custom-class="body_text">Mobile Device Data.</span></em><span data-custom-class="body_text"> We may automatically collect device information (such as your mobile device ID, model and manufacturer), operating system, version information and IP address.</span></li>
<li><em><span data-custom-class="body_text">Push Notifications.</span></em><span data-custom-class="body_text"> We may request to send you push notifications regarding your account or the mobile application. If you wish to opt-out from receiving these types of communications, you may turn them off in your device’s settings.</span></li>
<li><em><span data-custom-class="body_text">Email Address.</span></em><span data-custom-class="body_text"> We may ask for your email address in order for you to log into the mobile application and share your data across devices.</span></li>
<li><em>Date of Birth</em>. We may ask you for your date of birth to ensure you are an appropriate age to use the mobile application and to generate aggregate statistics of our users.</li>
</ul>
<hr />
<p><strong><span data-custom-class="heading_1">2. HOW DO WE USE YOUR INFORMATION?</span> </strong></p>
<p><strong><em><span data-custom-class="body_text">In Short:</span> </em> </strong><em><span data-custom-class="body_text">We process your information for purposes based on legitimate business interests, the fulfillment of our contract with you, compliance with our legal obligations, and/or your consent.</span></em><span data-custom-class="body_text">We use personal information collected via our Apps for a variety of business purposes described below. We process your personal information for these purposes in reliance on our legitimate business interests, in order to enter into or perform a contract with you, with your consent, and/or for compliance with our legal obligations. We indicate the specific processing grounds we rely on next to each purpose listed below.</span></p>
<p><span data-custom-class="body_text">We use the information we collect or receive:</span></p>
<ul>
<li><strong><span data-custom-class="body_text">To facilitate account creation and logon process.</span></strong><span data-custom-class="body_text"> If you choose to link your account with us to a third party account (such as your Google or Facebook account), we use the information you allowed us to collect from those third parties to facilitate account creation and logon process for the performance of the contract. See the section below headed &#8220;</span><span data-custom-class="body_text">HOW DO WE HANDLE YOUR SOCIAL LOGINS</span><span data-custom-class="body_text">&#8221; for further information.   </span></li>
<li><strong><span data-custom-class="body_text">To send you marketing and promotional communications.</span></strong><span data-custom-class="body_text"> We and/or our third party marketing partners may use the personal information you send to us for our marketing purposes, if this is in accordance with your marketing preferences. You can opt-out of our marketing emails at any time (see the &#8220;</span><span data-custom-class="body_text">WHAT ARE YOUR PRIVACY RIGHTS</span><span data-custom-class="body_text">&#8221; below).</span><span data-custom-class="body_text"> </span></li>
<li><strong><span data-custom-class="body_text">To send administrative information to you. </span></strong><span data-custom-class="body_text">We may use your personal information to send you product, service and new feature information and/or information about changes to our terms, conditions, and policies.</span></li>
<li><strong><span data-custom-class="body_text">Fulfill and manage your orders.</span></strong><span data-custom-class="body_text"> We may use your information to fulfill and manage your orders, payments, returns, and exchanges made through the Apps.</span><span data-custom-class="body_text"> </span></li>
<li><strong><span data-custom-class="body_text">Request Feedback.</span></strong><span data-custom-class="body_text"> We may use your information to request feedback and to contact you about your use of our Apps.</span><span data-custom-class="body_text">  </span></li>
<li><strong><span data-custom-class="body_text">To enforce our terms, conditions and policies for Business Purposes, Legal Reasons and Contractual.</span></strong></li>
<li><strong><span data-custom-class="body_text">To respond to legal requests and prevent harm. </span></strong><span data-custom-class="body_text">If we receive a subpoena or other legal request, we may need to inspect the data we hold to determine how to respond.</span></li>
<li><span data-custom-class="body_text"><strong>To manage user accounts</strong>. We may use your information for the purposes of managing our account and keeping it in working order.                </span></li>
</ul>
<hr />
<p id="infoshare"><strong><span data-custom-class="heading_1">3. WILL YOUR INFORMATION BE SHARED WITH ANYONE?</span> </strong></p>
<p><strong><em><span data-custom-class="body_text">In Short:</span> </em> </strong><em><span data-custom-class="body_text">We only share information with your consent, to comply with laws, to provide you with services, to protect your rights, or to fulfill business obligations. </span></em></p>
<div><span data-custom-class="body_text">We may process or share data based on the following legal basis:</span></div>
<ul>
<li><span data-custom-class="body_text"><span data-custom-class="body_text"><strong>Consent:</strong> We may process your data if you have given us specific consent to use your personal information in a specific purpose.</span></span></li>
<li><span data-custom-class="body_text"><span data-custom-class="body_text"><strong>Legitimate Interests:</strong> We may process your data when it is reasonably necessary to achieve our legitimate business interests.</span></span></li>
<li><span data-custom-class="body_text"><span data-custom-class="body_text"><strong>Performance of a Contract: </strong>Where we have entered into a contract with you, we may process your personal information to fulfill the terms of our contract.</span></span></li>
<li><span data-custom-class="body_text"><span data-custom-class="body_text"><strong>Legal Obligations:</strong> We may disclose your information where we are legally required to do so in order to comply with applicable law, governmental requests, a judicial proceeding, court order, or legal process, such as in response to a court order or a subpoena (including in response to public authorities to meet national security or law enforcement requirements).</span></span></li>
<li><span data-custom-class="body_text"><strong>Vital Interests:</strong> We may disclose your information where we believe it is necessary to investigate, prevent, or take action regarding potential violations of our policies, suspected fraud, situations involving potential threats to the safety of any person and illegal activities, or as evidence in litigation in which we are involved.</span></li>
</ul>
<p><span data-custom-class="body_text">More specifically, we may need to process your data or share your personal information in the following situations:</span> <span data-custom-class="body_text"> </span></p>
<ul>
<li><strong><span data-custom-class="body_text">Vendors, Consultants and Other Third-Party Service Providers.</span></strong><span data-custom-class="body_text"> We may share your data with third party vendors, service providers, contractors or agents who perform services for us or on our behalf and require access to such information to do that work. Examples include: payment processing, data analysis, email delivery, hosting services, customer service and marketing efforts. We may allow selected third parties to use tracking technology on the Apps, which will enable them to collect data about how you interact with the Apps over time. This information may be used to, among other things, analyze and track data, determine the popularity of certain content and better understand online activity. Unless described in this Policy, we do not share, sell, rent or trade any of your information with third parties for their promotional purposes.  </span></li>
<li><strong><span data-custom-class="body_text">Business Transfers.</span></strong><span data-custom-class="body_text"> We may share or transfer your information in connection with, or during negotiations of, any merger, sale of assets, financing, or acquisition of all or a portion of our business to another organization.</span></li>
<li><strong><span data-custom-class="body_text">Third-Party Advertisers.</span></strong><span data-custom-class="body_text"> We may use third-party advertising companies to serve ads when you visit the Apps. These companies may use information about your visits to our Website(s) and other websites that are contained in web cookies and other tracking technologies in order to provide advertisements about goods and services of interest to you. </span></li>
</ul>
<hr />
<p id="sociallogins"><strong><span data-custom-class="heading_1">4. HOW DO WE HANDLE YOUR SOCIAL LOGINS?</span> </strong></p>
<p><strong><em><span data-custom-class="body_text">In Short:</span> </em> </strong><em><span data-custom-class="body_text">If you choose to register or log in to our services using a social media account, we may have access to certain information about you.</span></em></p>
<p><span data-custom-class="body_text">Our Apps offer you the ability to register and login using your third party social media account details (like your Facebook or Twitter logins). Where you choose to do this, we will receive certain profile information about you from your social media provider. The profile Information we receive may vary depending on the social media provider concerned, but will often include your name, e-mail address, friends list, profile picture as well as other information you choose to make public.  </span></p>
<p><span data-custom-class="body_text">We will use the information we receive only for the purposes that are described in this privacy notice or that are otherwise made clear to you on the Apps. Please note that we do not control, and are not responsible for, other uses of your personal information by your third party social media provider. We recommend that you review their privacy policy to understand how they collect, use and share your personal information, and how you can set your privacy preferences on their sites and apps.</span></p>
<hr />
<p id="inforetain"><strong><span data-custom-class="heading_1">5. HOW LONG DO WE KEEP YOUR INFORMATION?</span> </strong></p>
<p><strong><em><span data-custom-class="body_text">In Short:</span> </em></strong><em><span data-custom-class="body_text">We keep your information for as long as necessary to fulfill the purposes outlined in this privacy notice unless otherwise required by law.</span> </em></p>
<p><span data-custom-class="body_text">We will only keep your personal information for as long as it is necessary for the purposes set out in this privacy notice, unless a longer retention period is required or permitted by law (such as tax, accounting or other legal requirements). No purpose in this policy will require us keeping your personal information for longer than the period of time in which users have an account with us.</span></p>
<p><span data-custom-class="body_text">When we have no ongoing legitimate business need to process your personal information, we will either delete or anonymize it, or, if this is not possible (for example, because your personal information has been stored in backup archives), then we will securely store your personal information and isolate it from any further processing until deletion is possible.</span></p>
<div>
<hr />
</div>
<p id="infosafe"><strong><span data-custom-class="heading_1">6. HOW DO WE KEEP YOUR INFORMATION SAFE? </span> </strong></p>
<p><strong><em><span data-custom-class="body_text">In Short:</span> </em> </strong><em><span data-custom-class="body_text">We aim to protect your personal information through a system of organizational and technical security measures.</span></em></p>
<p><span data-custom-class="body_text">We have implemented appropriate technical and organizational security measures designed to protect the security of any personal information we process. However, please also remember that we cannot guarantee that the internet itself is 100% secure. Although we will do our best to protect your personal information, transmission of personal information to and from our Apps is at your own risk. You should only access the services within a secure environment.</span><span data-custom-class="body_text">  </span></p>
<hr />
<p id="infominors"><strong><span data-custom-class="heading_1">7. DO WE COLLECT INFORMATION FROM MINORS?</span> </strong></p>
<p><strong><em><span data-custom-class="body_text">In Short:</span> </em> </strong><em><span data-custom-class="body_text">We do not knowingly collect data from or market to children under 18 years of age.</span></em></p>
<p><span data-custom-class="body_text">We do not knowingly solicit data from or market to children under 18 years of age. By using the Apps, you represent that you are at least 18 or that you are the parent or guardian of such a minor and consent to such minor dependent’s use of the Apps. If we learn that personal information from users less than 18 years of age has been collected, we will deactivate the account and take reasonable measures to promptly delete such data from our records. If you become aware of any data we have collected from children under age 18, please contact us at <a href="mailto:info@freethehops.org">info@freethehops.org</a>.</span><span data-custom-class="body_text"> </span></p>
<hr />
<p id="privacyrights"><strong><span data-custom-class="heading_1">8. WHAT ARE YOUR PRIVACY RIGHTS?</span> </strong></p>
<p><strong><em><span data-custom-class="body_text">In Short:</span> </em> </strong><span data-custom-class="body_text"><em>You may review, change, or terminate your account at any time.</em></span></p>
<p><span data-custom-class="body_text">If you are resident in the European Economic Area and you believe we are unlawfully processing your personal information, you also have the right to complain to your local data protection supervisory authority. You can find their contact details here:</span> <span data-custom-class="body_text"><a href="http://ec.europa.eu/justice/data-protection/bodies/authorities/index_en.htm" target="_blank" rel="noopener noreferrer" data-custom-class="link">http://ec.europa.eu/justice/data-protection/bodies/authorities/index_en.htm</a>. </span></p>
<p><strong><span data-custom-class="heading_2">Account Information</span></strong></p>
<p><span data-custom-class="body_text">If you would at any time like to review or change the information in your account or terminate your account, you can:</span></p>
<ul>
<li><span data-custom-class="body_text">Log into your account settings and update your user account.</span></li>
<li><span data-custom-class="body_text">Contact us using the contact information provided. </span></li>
</ul>
<p><span data-custom-class="body_text">Upon your request to terminate your account, we will deactivate or delete your account and information from our active databases. However, some information may be retained in our files to prevent fraud, troubleshoot problems, assist with any investigations, enforce our Terms of Use and/or comply with legal requirements.</span><span data-custom-class="body_text"> </span></p>
<p><strong><u><span data-custom-class="body_text">Opting out of email marketing:</span></u> </strong><span data-custom-class="body_text">You can unsubscribe from our marketing email list at any time by clicking on the unsubscribe link in the emails that we send or by contacting us using the details provided below. You will then be removed from the marketing email list – however, we will still need to send you service-related emails that are necessary for the administration and use of your account. </span></p>
</div>
<div>
<hr />
</div>
<p id="DNT"><strong><span data-custom-class="heading_1">9. CONTROLS FOR DO-NOT-TRACK FEATURES</span> </strong></p>
<p><span data-custom-class="body_text">Most web browsers and some mobile operating systems and mobile applications include a Do-Not-Track (“DNT”) feature or setting you can activate to signal your privacy preference not to have data about your online browsing activities monitored and collected. No uniform technology standard for recognizing and implementing DNT signals has been finalized. As such, we do not currently respond to DNT browser signals or any other mechanism that automatically communicates your choice not to be tracked online. If a standard for online tracking is adopted that we must follow in the future, we will inform you about that practice in a revised version of this privacy notice.</span></p>
<div>
<hr />
</div>
<p id="caresidents"><strong><span data-custom-class="heading_1">10. DO CALIFORNIA RESIDENTS HAVE SPECIFIC PRIVACY RIGHTS?</span> </strong></p>
<p><strong><em><span data-custom-class="body_text">In Short:</span> </em> </strong><em><span data-custom-class="body_text">Yes, if you are a resident of California, you are granted specific rights regarding access to your personal information. </span></em></p>
<p><span data-custom-class="body_text">California Civil Code Section 1798.83, also known as the “Shine The Light” law, permits our users who are California residents to request and obtain from us, once a year and free of charge, information about categories of personal information (if any) we disclosed to third parties for direct marketing purposes and the names and addresses of all third parties with which we shared personal information in the immediately preceding calendar year. If you are a California resident and would like to make such a request, please submit your request in writing to us using the contact information provided below.</span></p>
<p><span data-custom-class="body_text">If you are under 18 years of age, reside in California, and have a registered account with the Apps, you have the right to request removal of unwanted data that you publicly post on the Apps. To request removal of such data, please contact us using the contact information provided below, and include the email address associated with your account and a statement that you reside in California. We will make sure the data is not publicly displayed on the Apps, but please be aware that the data may not be completely or comprehensively removed from our systems.</span></p>
<hr />
<p id="policyupdates"><strong><span data-custom-class="heading_1">11. DO WE MAKE UPDATES TO THIS POLICY?</span> </strong></p>
<p><strong><em><span data-custom-class="body_text">In Short:</span> </em> </strong><em><span data-custom-class="body_text">Yes, we will update this policy as necessary to stay compliant with relevant laws.</span></em></p>
<p><span data-custom-class="body_text">We may update this privacy notice from time to time. The updated version will be indicated by an updated “Revised” date and the updated version will be effective as soon as it is accessible. If we make material changes to this privacy notice, we may notify you either by prominently posting a notice of such changes or by directly sending you a notification. We encourage you to review this privacy notice frequently to be informed of how we are protecting your information. </span></p>
<hr />
<p id="contact"><strong><span data-custom-class="heading_1">12. HOW CAN YOU CONTACT US ABOUT THIS POLICY?</span> </strong></p>
<p><span data-custom-class="body_text">If you have questions or comments about this policy, you may email us at <a href="mailto:info@freethehops.org">info@freethehops.org</a> or by post to:</span></p>
<div><span data-custom-class="body_text">Alabama Brewers Guild, Inc</span><span data-custom-class="body_text">  </span> <span data-custom-class="body_text"> </span></div>
<div><span data-custom-class="body_text">PO Box 55924 </span></div>
<div><span data-custom-class="body_text">Birmingham, AL 35222  </span><span data-custom-class="body_text">  </span></div>
<div><span data-custom-class="body_text">United States      </span><span data-custom-class="body_text"> </span></div>
							</div>
  ''';
}

