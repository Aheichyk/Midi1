#include <mega8.h>
#include <delay.h>

// Declare your global variables here

// USART Transmitter buffer 
unsigned char tx_buffer[3];

unsigned int send_count=0;
unsigned char tmp[31];
unsigned char first_on = 1;
unsigned char cnt = 0;

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
    send_count++;         
    
    if (send_count < 3) {
        UDR = tx_buffer[send_count];
    } else {
        send_count = 0;
    }
}

void send_key(unsigned char num, unsigned char input)
{
    if (first_on) {
        return;
    }   
    //Wait end of transmit
    while (!(UCSRA&(1<<UDRE)));
    
    if (!input) {
        tx_buffer[0] = 0x90;
        tx_buffer[1] = num;
        tx_buffer[2] = 0x60;
    } else {
        tx_buffer[0] = 0x80;
        tx_buffer[1] = num;
        tx_buffer[2] = 0x00; 
    }              
    
    send_count = 0; 
    UDR = tx_buffer[0];    
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
// State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P 
PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (1<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

// Port C initialization
// Function: Bit6=Out Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
DDRC=(1<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=0 Bit5=P Bit4=P Bit3=P Bit2=P Bit1=P Bit0=P
PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

// Port D initialization
DDRD=0xFF;
PORTD=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 31250
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
UCSRB=(0<<RXCIE) | (1<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
UBRRH=0x00;
UBRRL=0x0F;



// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here         
      if (cnt == 0) {
          PORTB = 0xFD;       
          if (PINC.0 != tmp[0]) { delay_ms(1); if (PINC.0 != tmp[0]) {send_key(24,PINC.0); tmp[0] = PINC.0; }}
          if (PINC.1 != tmp[1]) { delay_ms(1); if (PINC.1 != tmp[1]) {send_key(25,PINC.1); tmp[1] = PINC.1; }}
          if (PINC.2 != tmp[2]) { delay_ms(1); if (PINC.2 != tmp[2]) {send_key(26,PINC.2); tmp[2] = PINC.2; }}
          if (PINC.3 != tmp[3]) { delay_ms(1); if (PINC.3 != tmp[3]) {send_key(27,PINC.3); tmp[3] = PINC.3; }}
          if (PINC.4 != tmp[4]) { delay_ms(1); if (PINC.4 != tmp[4]) {send_key(28,PINC.4); tmp[4] = PINC.4; }}
          if (PINC.5 != tmp[5]) { delay_ms(1); if (PINC.5 != tmp[5]) {send_key(29,PINC.5); tmp[5] = PINC.5; }}  
      } else if (cnt == 1) {
          PORTB = 0xFB;
          if (PINC.0 != tmp[6]) { delay_ms(1); if (PINC.0 != tmp[6]) {send_key(30,PINC.0); tmp[6] = PINC.0; }}
          if (PINC.1 != tmp[7]) { delay_ms(1); if (PINC.1 != tmp[7]) {send_key(31,PINC.1); tmp[7] = PINC.1; }}
          if (PINC.2 != tmp[8]) { delay_ms(1); if (PINC.2 != tmp[8]) {send_key(32,PINC.2); tmp[8] = PINC.2; }}
          if (PINC.3 != tmp[9]) { delay_ms(1); if (PINC.3 != tmp[9]) {send_key(33,PINC.3); tmp[9] = PINC.3; }}
          if (PINC.4 != tmp[10]) { delay_ms(1); if (PINC.4 != tmp[10]) {send_key(34,PINC.4); tmp[10] = PINC.4; }}
          if (PINC.5 != tmp[11]) { delay_ms(1); if (PINC.5 != tmp[11]) {send_key(35,PINC.5); tmp[11] = PINC.5; }} 
      } else if (cnt == 2) {
          PORTB = 0xF7;
          if (PINC.0 != tmp[12]) { delay_ms(1); if (PINC.0 != tmp[12]) {send_key(36,PINC.0); tmp[12] = PINC.0; }}
          if (PINC.1 != tmp[13]) { delay_ms(1); if (PINC.1 != tmp[13]) {send_key(37,PINC.1); tmp[13] = PINC.1; }}
          if (PINC.2 != tmp[14]) { delay_ms(1); if (PINC.2 != tmp[14]) {send_key(38,PINC.2); tmp[14] = PINC.2; }}
          if (PINC.3 != tmp[15]) { delay_ms(1); if (PINC.3 != tmp[15]) {send_key(39,PINC.3); tmp[15] = PINC.3; }}
          if (PINC.4 != tmp[16]) { delay_ms(1); if (PINC.4 != tmp[16]) {send_key(40,PINC.4); tmp[16] = PINC.4; }}
          if (PINC.5 != tmp[17]) { delay_ms(1); if (PINC.5 != tmp[17]) {send_key(41,PINC.5); tmp[17] = PINC.5; }} 
      } else if (cnt == 3) {
          PORTB = 0xEF;    
          if (PINC.0 != tmp[18]) { delay_ms(1); if (PINC.0 != tmp[18]) {send_key(42,PINC.0); tmp[18] = PINC.0; }}
          if (PINC.1 != tmp[19]) { delay_ms(1); if (PINC.1 != tmp[19]) {send_key(43,PINC.1); tmp[19] = PINC.1; }}
          if (PINC.2 != tmp[20]) { delay_ms(1); if (PINC.2 != tmp[20]) {send_key(44,PINC.2); tmp[20] = PINC.2; }}
          if (PINC.3 != tmp[21]) { delay_ms(1); if (PINC.3 != tmp[21]) {send_key(45,PINC.3); tmp[21] = PINC.3; }}
          if (PINC.4 != tmp[22]) { delay_ms(1); if (PINC.4 != tmp[22]) {send_key(46,PINC.4); tmp[22] = PINC.4; }}
          if (PINC.5 != tmp[23]) { delay_ms(1); if (PINC.5 != tmp[23]) {send_key(47,PINC.5); tmp[23] = PINC.5; }}   
      } else if (cnt == 4) {
          PORTB = 0xDF;
          if (PINC.0 != tmp[24]) { delay_ms(1); if (PINC.0 != tmp[24]) {send_key(48,PINC.0); tmp[24] = PINC.0; }}
          if (PINC.1 != tmp[25]) { delay_ms(1); if (PINC.1 != tmp[25]) {send_key(49,PINC.1); tmp[25] = PINC.1; }}
          if (PINC.2 != tmp[26]) { delay_ms(1); if (PINC.2 != tmp[26]) {send_key(50,PINC.2); tmp[26] = PINC.2; }}
          if (PINC.3 != tmp[27]) { delay_ms(1); if (PINC.3 != tmp[27]) {send_key(51,PINC.3); tmp[27] = PINC.3; }}
          if (PINC.4 != tmp[28]) { delay_ms(1); if (PINC.4 != tmp[28]) {send_key(52,PINC.4); tmp[28] = PINC.4; }}
          if (PINC.5 != tmp[29]) { delay_ms(1); if (PINC.5 != tmp[29]) {send_key(53,PINC.5); tmp[29] = PINC.5; }}    
          first_on = 0; 
      }    
      cnt++;
      if (cnt > 4) {
        cnt = 0;
      }
      }
}
