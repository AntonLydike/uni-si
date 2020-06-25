#include <stdlib.h>
#include <stdio.h>
#include "/nix/store/zy0zc02h958l3lmn14jza2gfanw9dk9i-trafficlib/include/traffic.h"
#include <pthread.h> 



/* Map for libtraffic, C-header structure */

/* First the dimension of the map */
#define map_width 5
#define map_height 5

/* Now the map data */
static map_shorts map_def[] =
{
AU,__,SD,__,AU,
__,__,SV,__,__,
SG,SH,SC,SH,SE,
__,__,SV,__,__,
AU,__,SF,__,AU
};

typedef struct __tparms {
    int car_x;
    int car_y;
    directions dir;
} ThreadParameters;

void * car_thread(void *arg) {
    ThreadParameters *parms = (ThreadParameters *) arg;
    int x = parms->car_x,
        y = parms->car_y;

    int car_id = putCar(x, y, parms->dir, 0);

    if (car_id < 0) {
        printf("Invalid position for car: (%i, %i)", x, y);
        return NULL;
    }

    // move loop
    while (1) {
        moveCar(car_id, parms->dir);
    }
}

ThreadParameters t_parms(int x, int y, directions dir) {
    ThreadParameters parms;
    parms.car_x = x;
    parms.car_y = y;
    parms.dir = dir;
    return parms;
}

int main() {
    printf("working...");
    createMap (map_def, map_width, map_height, NULL);

    ThreadParameters parms_1 = t_parms(0, 2, O);
    ThreadParameters parms_2 = t_parms(2, 0, S);


    pthread_t p1, p2;
    pthread_create(&p1, NULL, car_thread, &parms_1);
    pthread_create(&p2, NULL, car_thread, &parms_2);

    pthread_join(p1, NULL);
    pthread_join(p2, NULL);

    destroyMap(0);
    return 0;
}

