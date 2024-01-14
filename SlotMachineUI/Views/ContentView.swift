//
//  ContentView.swift
//  SlotMachineUI
//
//  Created by Daniel Washington Ignacio on 11/01/24.
//

import SwiftUI


struct ContentView: View {
    //MARK: - Properteis
    
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    let haptics = UINotificationFeedbackGenerator()
    
    @State private var highscore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    @State private var reels: Array = [0, 1, 2]
    @State private var showingInfoView: Bool = false
    @State private var isActiveBet10: Bool = true
    @State private var isActiveBet20: Bool = false
    @State private var showingModal: Bool = false
    @State private var animatingSymbol: Bool = false
    @State private var animatingModel: Bool = false
    
    //MARK: - Functions
    
    // Spin the reels
    func spinReels() {
        //reels[0] = Int.random(in: 0...symbols.count - 1)
        //reels[1] = Int.random(in: 0...symbols.count - 1)
        //reels[2] = Int.random(in: 0...symbols.count - 1)
        
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        playSound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    // Check the winning
    func checkWinning() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2] {
            // Player wins
            playerWins()
            
            // New Highscore
            if coins > highscore {
                newHighScore()
            } else {
                playSound(sound: "win", type: "mp3")
            }
        } else {
            // Player loses
            playerLoses()
        }
    }

    func playerWins(){
        coins += betAmount * 10
    }
    
    func newHighScore() {
        highscore = coins
        UserDefaults.standard.set(highscore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    
    func playerLoses() {
        coins -= betAmount
    }
    
    func activeBet20() {
        betAmount = 20
        isActiveBet20 = true
        isActiveBet10 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func activeBet10(){
        betAmount = 10
        isActiveBet10 = true
        isActiveBet20 = false
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    // Game is over
    func isGameOver(){
        if coins <= 0 {
            // Show Modal Window
            showingModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame() {
        UserDefaults.standard.set(0, forKey: "HighScore")
        highscore = 0
        coins = 100
        activeBet10()
        playSound(sound: "chimeup", type: "mp3")
    }
    
    //MARK: - Body
    var body: some View {
        ZStack {
            //MARK: - Background
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            
            //MARK: - Interface
            VStack(alignment: .center, spacing: 5) {
                //MARK: - Header
                
                LogoView()
                
                Spacer()
                
                //MARK: - Score
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                            
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        
                        Text("\(highscore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)

                    }
                    .modifier(ScoreContainerModifier())
                }
                
                //MARK: - Slot Machine
                
                VStack(alignment: .center, spacing: 0) {
                    //MARK: - Reel #1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)))
                            .onAppear(perform: {
                                self.animatingSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            })
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                    
                    //MARK: - Reel #2
                    ZStack {
                        ReelView()
                        Image(symbols[reels[1]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.7...0.9)))
                            .onAppear(perform: {
                                self.animatingSymbol.toggle()
                            })
                    }
                        
                        Spacer()
                        
                    //MARK: - Reel #3
                    ZStack {
                        ReelView()
                        Image(symbols[reels[2]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.9...1.1)))
                            .onAppear(perform: {
                                self.animatingSymbol.toggle()
                            })
                    }
                }
                    .frame(maxWidth: 500)
                    
                    
                    //MARK: - Spin Button
                    Button(action: {
                        // 1. Set the default state: no animation
                        withAnimation{
                            self.animatingSymbol = false
                        }
                        
                        // 2. Spin the reels
                        self.spinReels()
                        
                        // 3. Trigger the animation after changing the symbols
                        withAnimation{
                            self.animatingSymbol = true
                        }
                        
                        // 4. check Winning
                        self.checkWinning()
                        
                        // 5. Game is over
                        self.isGameOver()
                    }) {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                    }
                    
                    
                }
                .layoutPriority(2)
                
                
                //MARK: - Footer
                
                Spacer()
                
                HStack {
                  //MARK: - Bet 20
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            self.activeBet20()
                        }) {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(isActiveBet20 ? Color("ColorYellow") : .white)
                                .modifier(BetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: isActiveBet20 ? 0 : 20)
                            .opacity(isActiveBet20 ? 1 : 0)
                            .modifier(CassinoChipModifier())
                            .modifier(ShadowModifier())
                    }
                    
                    Spacer()
                    
                    //MARK: - Bet 10
                      HStack(alignment: .center, spacing: 10) {
                          Image("gfx-casino-chips")
                              .resizable()
                              .opacity(isActiveBet10 ? 1 : 0)
                              .offset(x: isActiveBet10 ? 0 : -20)
                              .modifier(CassinoChipModifier())
                              .modifier(ShadowModifier())
                          
                          
                          Button(action: {
                              self.activeBet10()
                          }) {
                              Text("10")
                                  .fontWeight(.heavy)
                                  .foregroundColor(isActiveBet10 ? Color("ColorYellow") : .white)
                                  .modifier(BetNumberModifier())
                          }
                          .modifier(BetCapsuleModifier())
                          
                      }
                }
            }
            
            //MARK: - Buttons
            
            .overlay(
                // Reset
                Button(action: {
                    print("Reset the game")
                    self.resetGame()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                }
                    .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            
            .overlay(
                // Info
                Button(action: {
                    self.showingInfoView = true
                }) {
                    Image(systemName: "info.circle")
                }
                    .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModal.wrappedValue ? 5 : 0 , opaque: false)
            
            
            //MARK: - Popup
            if $showingModal.wrappedValue {
                ZStack {
                    Color(Color("ColorTransparentBlack")).edgesIgnoringSafeArea(.all)
                    
                    // Modal
                    VStack(spacing: 0) {
                        // Title
                        Text("GAME OVER")
                            .font(.system(.title,design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Message
                        
                        VStack(alignment: .center, spacing: 16) {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            
                            Text("Bad luck! You lost all of the coins. \nLet's play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .layoutPriority(1)
                            
                            Button(action: {
                                self.showingModal = false
                                self.animatingModel = false
                                self.activeBet10()
                                self.coins = 100
                            }) {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(Color("ColorPink"))
                                    )
                            }
                        }
                        
                        Spacer()
                         
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: Color("TransparentBlack"), radius: 6, x:0 , y:8)
                    .opacity($animatingModel.wrappedValue ? 1 : 0)
                    .offset(x: $animatingModel.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .onAppear(perform: {
                        self.animatingModel = true
                    })
                }
            }
            
        }
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
    }
}

//MARK: - preview
#Preview {
    ContentView()
}
